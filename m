From: Bart Van Assche <Bart.VanAssche@wdc.com>
Subject: Re: [PATCH 21/29] scsi: aacraid: Refactor resolve luns code and scsi
 functions
Date: Thu, 21 Dec 2017 18:42:38 +0000
Message-ID: <1513881757.2931.23.camel@wdc.com>
References: <20171221173420.8213-1-RaghavaAditya.Renukunta@microsemi.com>
         <20171221173420.8213-22-RaghavaAditya.Renukunta@microsemi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from esa1.hgst.iphmx.com ([68.232.141.245]:38802 "EHLO
        esa1.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752944AbdLUSmk (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 21 Dec 2017 13:42:40 -0500
In-Reply-To: <20171221173420.8213-22-RaghavaAditya.Renukunta@microsemi.com>
Content-Language: en-US
Content-ID: <35B8908F6F8B454C8BB005F45B6D4D86@namprd04.prod.outlook.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "jejb@linux.vnet.ibm.com" <jejb@linux.vnet.ibm.com>, "RaghavaAditya.Renukunta@microsemi.com" <RaghavaAditya.Renukunta@microsemi.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "martin.petersen@oracle.com" <martin.petersen@oracle.com>
Cc: "aacraid@microsemi.com" <aacraid@microsemi.com>, "gpiccoli@linux.vnet.ibm.com" <gpiccoli@linux.vnet.ibm.com>, "tom.white@microsemi.com" <tom.white@microsemi.com>, "Scott.Benesh@microsemi.com" <Scott.Benesh@microsemi.com>

T24gVGh1LCAyMDE3LTEyLTIxIGF0IDA5OjM0IC0wODAwLCBSYWdoYXZhIEFkaXR5YSBSZW51a3Vu
dGEgd3JvdGU6DQo+ICsJaWYgKGJ1cyA9PSBDT05UQUlORVJfQ0hBTk5FTCkNCj4gKwkJYnVzID0g
Q09OVEFJTkVSX0NIQU5ORUw7DQoNClNvcnJ5IGJ1dCBJIGRvbid0IHNlZSBob3cgdGhlIGFib3Zl
IGNvZGUgY2FuIGJlIHVzZWZ1bD8NCg0KVGhhbmtzLA0KDQpCYXJ0Lg==
