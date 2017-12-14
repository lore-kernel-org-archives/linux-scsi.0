From: Bart Van Assche <Bart.VanAssche@wdc.com>
Subject: Re: [PATCH 3/4] scsi: add missing get_device() return value checks
Date: Thu, 14 Dec 2017 22:03:46 +0000
Message-ID: <1513289025.2475.82.camel@sandisk.com>
References: <1513069072-32514-1-git-send-email-hare@suse.de>
         <1513069072-32514-4-git-send-email-hare@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from esa2.hgst.iphmx.com ([68.232.143.124]:49207 "EHLO
        esa2.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753236AbdLNWDr (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 14 Dec 2017 17:03:47 -0500
In-Reply-To: <1513069072-32514-4-git-send-email-hare@suse.de>
Content-Language: en-US
Content-ID: <DCAF5044FA26524CBD589B2691CF8FE9@namprd04.prod.outlook.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "hare@suse.de" <hare@suse.de>, "martin.petersen@oracle.com" <martin.petersen@oracle.com>
Cc: "hch@lst.de" <hch@lst.de>, "james.bottomley@hansenpartnership.com" <james.bottomley@hansenpartnership.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "hare@suse.com" <hare@suse.com>

T24gVHVlLCAyMDE3LTEyLTEyIGF0IDA5OjU3ICswMTAwLCBIYW5uZXMgUmVpbmVja2Ugd3JvdGU6
DQo+ICAJc2Rldi0+c2Rldl9nZW5kZXYucGFyZW50ID0gZ2V0X2RldmljZSgmc3RhcmdldC0+ZGV2
KTsNCj4gKwlpZiAoIXNkZXYtPnNkZXZfZ2VuZGV2LnBhcmVudCkgew0KPiArCQlrZnJlZShzZGV2
KTsNCj4gKwkJcmV0dXJuIE5VTEw7DQo+ICsJfQ0KDQpBcmUgeW91IHN1cmUgdGhhdCBnZXRfZGV2
aWNlKCkgY2FuIHJldHVybiBOVUxMPw0KDQpUaGFua3MsDQoNCkJhcnQu
