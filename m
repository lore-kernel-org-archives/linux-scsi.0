From: David Laight <David.Laight@ACULAB.COM>
Subject: RE: [PATCH 3.12 033/118] usb: xhci: Link TRB must not occur within
 a USB payload burst
Date: Tue, 7 Jan 2014 13:58:32 +0000
Message-ID: <063D6719AE5E284EB5DD2968C1650D6D453E1A@AcuExch.aculab.com>
References: <20131218211219.461663463@linuxfoundation.org>
 <20131218211220.412278148@linuxfoundation.org> <52C32BB0.90600@gmail.com>
 <20140102191510.GA9621@xanatos> <52C6D9F1.9000709@gmail.com>
 <20140103195455.GA4193@xanatos> <52C729CE.9050307@gmail.com>
 <20140103232929.GD4193@xanatos> <20140107003157.GA7963@xanatos>
 <52CC014C.5060604@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <stable-owner@vger.kernel.org>
In-Reply-To: <52CC014C.5060604@gmail.com>
Content-Language: en-US
Sender: stable-owner@vger.kernel.org
To: 'walt' <w41ter@gmail.com>, Sarah Sharp <sarah.a.sharp@linux.intel.com>
Cc: Alan Stern <stern@rowland.harvard.edu>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Linux Kernel <linux-kernel@vger.kernel.org>, "stable@vger.kernel.org" <stable@vger.kernel.org>, "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

VGhlIGRtZXNnIGNvbnRhaW5zOg0KDQpbICA1MzguNzI4MDY0XSBFWFQ0LWZzIHdhcm5pbmcgKGRl
dmljZSBkbS0wKTogZXh0NF9lbmRfYmlvOjMxNjogSS9PIGVycm9yIHdyaXRpbmcgdG8gaW5vZGUg
MjMzMzA4NjUgKG9mZnNldCAwIHNpemUgODM4ODYwOCBzdGFydGluZyBibG9jayA4MTI2MjgpDQoN
CkFuIDhNQiB0cmFuc2ZlciB3aWxsIG5lZWQgYXQgbGVhc3QgMTI4IHJpbmcgZW50cmllcyAoVFJC
KSBldmVuIGlmIHRoZSByZXF1ZXN0DQppcyBhIHNpbmdsZSBjb250aWd1b3VzIG1lbW9yeSBibG9j
ay4NCg0KQXJlIHlvdSB1c2luZyB0aGUgcGF0Y2ggdGhhdCBpbmNyZWFzZXMgdGhlIHJpbmcgc2l6
ZSBmcm9tIDY0IHRvIDI1Nj8NCg0KCURhdmlkDQoNCg==
