From: Bart Van Assche <Bart.VanAssche@wdc.com>
Subject: Re: [PATCH] scsi: Remove unnecessary condition in
 sd_read_block_limits()
Date: Wed, 13 Sep 2017 17:32:48 +0000
Message-ID: <1505323966.2654.5.camel@wdc.com>
References: <1505312986-14777-1-git-send-email-lczerner@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from esa4.hgst.iphmx.com ([216.71.154.42]:13654 "EHLO
        esa4.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751063AbdIMRde (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 13 Sep 2017 13:33:34 -0400
In-Reply-To: <1505312986-14777-1-git-send-email-lczerner@redhat.com>
Content-Language: en-US
Content-ID: <83FC569ED11E944EB9B9D3FB4E457519@namprd04.prod.outlook.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "lczerner@redhat.com" <lczerner@redhat.com>

T24gV2VkLCAyMDE3LTA5LTEzIGF0IDE2OjI5ICswMjAwLCBMdWthcyBDemVybmVyIHdyb3RlOg0K
PiBBZnRlciBzZXJpZXMgb2YgY2hhbmdlcyBhcm91bmQgV1JJVEVfU0FNRSBhbmQgVU5NQVAgc2V0
dXAgd2UgZW5kZWQgdXANCj4gd2l0aCBsZWZ0b3ZlciB1bm5lY2Vzc2FyeSBjb25kaXRpb24uIFJl
bW92ZSBpdC4NCg0KQSBzaW1pbGFyIHBhdGNoIHdhcyBzaXR0aW5nIGluIG15IHRyZWUgYW5kIHdh
aXRpbmcgdG8gYmUgcG9zdGVkLiBCdXQgc2luY2UgeW91DQpwb3N0ZWQgdGhpcyBmaXJzdDoNCg0K
UmV2aWV3ZWQtYnk6IEJhcnQgVmFuIEFzc2NoZSA8YmFydC52YW5hc3NjaGVAd2RjLmNvbT4NCg0K
