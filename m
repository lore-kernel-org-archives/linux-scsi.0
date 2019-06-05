From: Avri Altman <Avri.Altman@wdc.com>
Subject: RE: [PATCH 0/3] (Qualcomm) UFS device reset support
Date: Wed, 5 Jun 2019 05:50:36 +0000
Message-ID: <SN6PR04MB4925530F216E86F6404FE14CFC160@SN6PR04MB4925.namprd04.prod.outlook.com>
References: <20190604072001.9288-1-bjorn.andersson@linaro.org>
 <CANcMJZBmgWMZu7Y53Lnx_x3L2UpCmEbFRHVW0SFCXfW=Yw9uYg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CANcMJZBmgWMZu7Y53Lnx_x3L2UpCmEbFRHVW0SFCXfW=Yw9uYg@mail.gmail.com>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: John Stultz <john.stultz@linaro.org>, Bjorn Andersson <bjorn.andersson@linaro.org>
Cc: Andy Gross <agross@kernel.org>, Linus Walleij <linus.walleij@linaro.org>, Rob Herring <robh+dt@kernel.org>, Mark Rutland <mark.rutland@arm.com>, Pedro Sousa <pedrom.sousa@synopsys.com>, "James E.J. Bottomley" <jejb@linux.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, "linux-arm-msm@vger.kernel.org" <linux-arm-msm@vger.kernel.org>, "linux-gpio@vger.kernel.org" <linux-gpio@vger.kernel.org>, "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

SGksDQoNCj4gDQo+IE9uIFR1ZSwgSnVuIDQsIDIwMTkgYXQgMTI6MjIgQU0gQmpvcm4gQW5kZXJz
c29uDQo+IDxiam9ybi5hbmRlcnNzb25AbGluYXJvLm9yZz4gd3JvdGU6DQo+ID4NCj4gPiBUaGlz
IHNlcmllcyBleHBvc2VzIHRoZSB1ZnNfcmVzZXQgbGluZSBhcyBhIGdwaW8sIGFkZHMgc3VwcG9y
dCBmb3IgdWZzaGNkIHRvDQo+ID4gYWNxdWlyZSBhbmQgdG9nZ2xlIHRoaXMgYW5kIHRoZW4gYWRk
cyB0aGlzIHRvIFNETTg0NSBNVFAuDQo+ID4NCj4gPiBCam9ybiBBbmRlcnNzb24gKDMpOg0KPiA+
ICAgcGluY3RybDogcWNvbTogc2RtODQ1OiBFeHBvc2UgdWZzX3Jlc2V0IGFzIGdwaW8NCj4gPiAg
IHNjc2k6IHVmczogQWxsb3cgcmVzZXR0aW5nIHRoZSBVRlMgZGV2aWNlDQo+ID4gICBhcm02NDog
ZHRzOiBxY29tOiBzZG04NDUtbXRwOiBTcGVjaWZ5IFVGUyBkZXZpY2UtcmVzZXQgR1BJTw0KPiAN
Cj4gQWRkaW5nIHNpbWlsYXIgY2hhbmdlIGFzIGluIHNkbTg0NS1tdHAgdG8gdGhlIG5vdCB5ZXQg
dXBzdHJlYW0NCj4gYmx1ZWxpbmUgZHRzLCBJIHZhbGlkYXRlZCB0aGlzIGFsbG93cyBteSBtaWNy
b24gVUZTIHBpeGVsMyB0byBib290Lg0KPiANCj4gVGVzdGVkLWJ5OiBKb2huIFN0dWx0eiA8am9o
bi5zdHVsdHpAbGluYXJvLm9yZz4NCk1heWJlIHVmc19oYmFfdmFyaWFudF9vcHMgd291bGQgYmUg
dGhlIHByb3BlciBwbGFjZSB0byBhZGQgdGhpcz8NCg0KVGhhbmtzLA0KQXZyaQ0KDQoNCg0KPiAN
Cj4gdGhhbmtzDQo+IC1qb2huDQo=
