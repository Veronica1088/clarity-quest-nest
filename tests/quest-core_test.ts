import { Clarinet, Tx, Chain, Account, types } from 'https://deno.land/x/clarinet@v1.0.0/index.ts';
import { assertEquals } from 'https://deno.land/std@0.90.0/testing/asserts.ts';

Clarinet.test({
  name: "Ensure that users can create quests",
  async fn(chain: Chain, accounts: Map<string, Account>) {
    const wallet_1 = accounts.get("wallet_1")!;
    
    let block = chain.mineBlock([
      Tx.contractCall("quest-core", "create-quest", [
        types.ascii("Learn Clarity"),
        types.ascii("Complete a Clarity tutorial"),
        types.ascii("Github repo link"),
        types.uint(100)
      ], wallet_1.address)
    ]);
    
    assertEquals(block.receipts.length, 1);
    assertEquals(block.height, 2);
    
    block.receipts[0].result.expectOk().expectUint(0);
  },
});
