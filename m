From: Bart Van Assche <Bart.VanAssche@wdc.com>
Subject: Re: [PATCH 2/2] sg: fixup infoleak when using SG_GET_REQUEST_TABLE
Date: Fri, 15 Sep 2017 14:29:22 +0000
Message-ID: <1505485760.2852.1.camel@wdc.com>
References: <1505477116-75013-1-git-send-email-hare@suse.de>
         <1505477116-75013-3-git-send-email-hare@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from esa1.hgst.iphmx.com ([68.232.141.245]:58312 "EHLO
        esa1.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751458AbdIOOaI (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 15 Sep 2017 10:30:08 -0400
In-Reply-To: <1505477116-75013-3-git-send-email-hare@suse.de>
Content-Language: en-US
Content-ID: <B8258B6B7D41284F9895D45F7D5CAA93@namprd04.prod.outlook.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "hare@suse.de" <hare@suse.de>, "martin.petersen@oracle.com" <martin.petersen@oracle.com>
Cc: "security@kernel.org" <security@kernel.org>, "hch@lst.de" <hch@lst.de>, "dvyukov@google.com" <dvyukov@google.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "mingo@redhat.com" <mingo@redhat.com>, "hare@suse.com" <hare@suse.com>, "james.bottomley@hansenpartnership.com" <james.bottomley@hansenpartnership.com>, "glider@google.com" <glider@google.com>

T24gRnJpLCAyMDE3LTA5LTE1IGF0IDE0OjA1ICswMjAwLCBIYW5uZXMgUmVpbmVja2Ugd3JvdGU6
DQo+IFdoZW4gY2FsbGluZyBTR19HRVRfUkVRVUVTVF9UQUJMRSBpb2N0bCB0aGF0IG9ubHkgYSBo
YWxmLWZpbGxlZA0KPiB0YWJsZSBpcyByZXR1cm5lZDsgdGhlIHJlbWFpbmluZyBwYXJ0IHdpbGwg
dGhlbiBjb250YWluIHN0YWxlDQo+IGtlcm5lbCBtZW1vcnkgaW5mb3JtYXRpb24uDQo+IFRoaXMg
cGF0Y2ggemVyb2VzIG91dCB0aGUgZW50aXJlIHRhYmxlIHRvIGF2b2lkIHRoaXMgaXNzdWUuDQoN
ClJldmlld2VkLWJ5OiBCYXJ0IFZhbiBBc3NjaGUgPGJhcnQudmFuYXNzY2hlQHdkYy5jb20+DQo=
