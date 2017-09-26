From: Bart Van Assche <Bart.VanAssche@wdc.com>
Subject: Re: [PATCH] scsi: ioctl reset should wait for IOs to complete
Date: Tue, 26 Sep 2017 18:24:46 +0000
Message-ID: <1506450273.3063.10.camel@wdc.com>
References: <20170926172235.29530-1-lduncan@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from esa6.hgst.iphmx.com ([216.71.154.45]:29447 "EHLO
        esa6.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S967715AbdIZSYx (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 26 Sep 2017 14:24:53 -0400
In-Reply-To: <20170926172235.29530-1-lduncan@suse.com>
Content-Language: en-US
Content-ID: <E8930C027577FA43AC032FAA70758A45@namprd04.prod.outlook.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "lduncan@suse.com" <lduncan@suse.com>
Cc: "jejb@linux.vnet.ibm.com" <jejb@linux.vnet.ibm.com>, "hare@suse.com" <hare@suse.com>, "martin.petersen@oracle.com" <martin.petersen@oracle.com>

T24gVHVlLCAyMDE3LTA5LTI2IGF0IDEwOjIyIC0wNzAwLCBMZWUgRHVuY2FuIHdyb3RlOg0KPiBU
aGUgU0NTSSBpb2N0bCByZXNldCBwYXRoIGlzIHNtYXJ0IGVub3VnaCB0byBzZXQgdGhlDQo+IGZs
YWcgdG1mX2luX3Byb2dyZXNzIHdoZW4gYSB1c2VyLXJlcXVlc3RlZCByZXNldCBpcw0KPiBwcm9j
ZXNzZWQsIGJ1dCBpdCBkb2VzIG5vdCB3YWl0IGZvciBJTyB0aGF0IGlzIGluDQo+IGZsaWdodC4g
VGhpcyBjYW4gcmVzdWx0IGluIGxvc3QgSU9zIGFuZCBodW5nDQo+IHByb2Nlc3Nlcy4gV2Ugc2hv
dWxkIHdhaXQgZm9yIGEgcmVhc29uYWJsZSBhbW91bnQNCj4gb2YgdGltZSBmb3IgZWl0aGVyIHRo
ZSBJT3MgdG8gY29tcGxldGUgb3IgdG8gZmFpbA0KPiB0aGUgcmVxdWVzdC4NCg0KSGVsbG8gTGVl
LA0KDQpJJ20gdXNpbmcgdGhpcyBmdW5jdGlvbmFsaXR5IGFsbCB0aGUgdGltZSB0byB0ZXN0IGhv
dyBTQ1NJIHRhcmdldCBjb2RlIGhhbmRsZXMNClRNRnMgd2hpbGUgU0NTSSBjb21tYW5kcyBhcmUg
aW4gcHJvZ3Jlc3MuIFNvIEkgd291bGQgcmVncmV0IGlmIHRoZSBTQ1NJIHJlc2V0DQppb2N0bCBj
b2RlIHdvdWxkIGJlIG1vZGlmaWVkIHN1Y2ggdGhhdCBpdCB3YWl0cyBmb3Igb3V0c3RhbmRpbmcg
cmVxdWVzdHMuDQpJc24ndCB0aGUgYmVoYXZpb3IgeW91IGRlc2NyaWJlZCBhIFNDU0kgTExEIGJ1
Zz8gU2hvdWxkbid0IHN1Y2ggYnVncyBiZSBmaXhlZA0KaW5zdGVhZCBvZiBpbXBsZW1lbnRpbmcg
YSB3b3JrLWFyb3VuZCBpbiB0aGUgU0NTSSBjb3JlPw0KDQpUaGFua3MsDQoNCkJhcnQu
