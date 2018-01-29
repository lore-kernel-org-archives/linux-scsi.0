From: Bart Van Assche <Bart.VanAssche@wdc.com>
Subject: Re: [PATCH resend 2/6] cdrom: factor out common open_for_* code
Date: Mon, 29 Jan 2018 17:02:01 +0000
Message-ID: <1517245320.2687.14.camel@wdc.com>
References: <cover.1516985620.git.msuchanek@suse.de>
         <0aa00d6ea4d9a7d02a27e6b08b64ae3eaf4d1b40.1516985620.git.msuchanek@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <0aa00d6ea4d9a7d02a27e6b08b64ae3eaf4d1b40.1516985620.git.msuchanek@suse.de>
Content-Language: en-US
Content-ID: <4E41E42390F8424F92EB9269D3D2B795@namprd04.prod.outlook.com>
Sender: linux-kernel-owner@vger.kernel.org
To: "corbet@lwn.net" <corbet@lwn.net>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "linux-ide@vger.kernel.org" <linux-ide@vger.kernel.org>, "keescook@chromium.org" <keescook@chromium.org>, "msuchanek@suse.de" <msuchanek@suse.de>, "tglx@linutronix.de" <tglx@linutronix.de>, "martin.petersen@oracle.com" <martin.petersen@oracle.com>, "axboe@kernel.dk" <axboe@kernel.dk>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "kstewart@linuxfoundation.org" <kstewart@linuxfoundation.org>, "pombredanne@nexb.com" <pombredanne@nexb.com>, "bp@alien8.de" <bp@alien8.de>, "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>, "jejb@linux.vnet.ibm.com" <jejb@linux.vnet.ibm.com>, "christophe.jaillet@wanadoo.fr" <christophe.jaillet@wanadoo.fr>, davem@davemlof
List-Id: linux-scsi@vger.kernel.org

T24gRnJpLCAyMDE4LTAxLTI2IGF0IDE3OjU4ICswMTAwLCBNaWNoYWwgU3VjaGFuZWsgd3JvdGU6
DQo+IC0JCQkJcmV0PWNkby0+dHJheV9tb3ZlKGNkaSwwKTsNCj4gKwkJCQlyZXQgPSBjZG8tPnRy
YXlfbW92ZShjZGksIDApOw0KDQpQbGVhc2Ugc2VwYXJhdGUgd2hpdGVzcGFjZS1vbmx5IGNoYW5n
ZXMgZnJvbSBmdW5jdGlvbmFsIGNoYW5nZXMgc3VjaCB0aGF0DQp0aGlzIHBhdGNoIHNlcmllcyBi
ZWNvbWVzIGVhc2llciB0byByZXZpZXcuDQoNClRoYW5rcywNCg0KQmFydC4NCg0KDQo=
