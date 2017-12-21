From: Bart Van Assche <Bart.VanAssche@wdc.com>
Subject: Re: [PATCH 15/29] scsi: aacraid: Create helper functions to get lun
 info
Date: Thu, 21 Dec 2017 18:40:45 +0000
Message-ID: <1513881642.2931.22.camel@wdc.com>
References: <20171221173420.8213-1-RaghavaAditya.Renukunta@microsemi.com>
         <20171221173420.8213-16-RaghavaAditya.Renukunta@microsemi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from esa5.hgst.iphmx.com ([216.71.153.144]:31881 "EHLO
        esa5.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752165AbdLUSkr (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 21 Dec 2017 13:40:47 -0500
In-Reply-To: <20171221173420.8213-16-RaghavaAditya.Renukunta@microsemi.com>
Content-Language: en-US
Content-ID: <AD45034BA67A80499A95EAA291356FD0@namprd04.prod.outlook.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "jejb@linux.vnet.ibm.com" <jejb@linux.vnet.ibm.com>, "RaghavaAditya.Renukunta@microsemi.com" <RaghavaAditya.Renukunta@microsemi.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "martin.petersen@oracle.com" <martin.petersen@oracle.com>
Cc: "aacraid@microsemi.com" <aacraid@microsemi.com>, "gpiccoli@linux.vnet.ibm.com" <gpiccoli@linux.vnet.ibm.com>, "tom.white@microsemi.com" <tom.white@microsemi.com>, "Scott.Benesh@microsemi.com" <Scott.Benesh@microsemi.com>

T24gVGh1LCAyMDE3LTEyLTIxIGF0IDA5OjM0IC0wODAwLCBSYWdoYXZhIEFkaXR5YSBSZW51a3Vu
dGEgd3JvdGU6DQo+ICsJcmV0dXJuICgocGh5c19sdW5zLT5saXN0X2xlbmd0aFswXTw8MjQpICsN
Cj4gKwkJCShwaHlzX2x1bnMtPmxpc3RfbGVuZ3RoWzFdPDwxNikgKw0KPiArCQkJKHBoeXNfbHVu
cy0+bGlzdF9sZW5ndGhbMl08PDgpICsNCj4gKwkJCShwaHlzX2x1bnMtPmxpc3RfbGVuZ3RoWzNd
KSkgLyAyNDsNCg0KUGxlYXNlIHVzZSBnZXRfdW5hbGlnbmVkX2JlMzIoKSBpbnN0ZWFkIG9mIG9w
ZW4tY29kaW5nIGl0Lg0KDQpUaGFua3MsDQoNCkJhcnQu
