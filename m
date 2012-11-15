From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH 1/5] arcmsr: Re-name the HBA Type
Date: Thu, 15 Nov 2012 07:00:22 -0800
Message-ID: <1352991622.2578.9.camel@dabdike>
References: <85E5FCE3D4AD4A2D9A3DE6E64060AF05@arecaaebe11fae>
	 <1352988719.2578.5.camel@dabdike>
	 <CAGUPPa5rmZoG0tf3o6GSqcjUwdnd5+CPfy1WkSoO0doFv6eh4Q@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CAGUPPa5rmZoG0tf3o6GSqcjUwdnd5+CPfy1WkSoO0doFv6eh4Q@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: =?UTF-8?Q?=E9=84=AD=E5=AE=88=E8=AC=99?= <nick.cheng@areca.com.tw>
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Thu, 2012-11-15 at 22:53 +0800, =E9=84=AD=E5=AE=88=E8=AC=99 wrote:
> Hi James,
> You got these errors/warnings before or after you apply these 5 patch=
es?

I got all of this lot from patch 1/5 only.  Please fix at least the
errors and the warnings that go to whitespace issues.  I don't really
care about printk(KERN_ERR vs pr_err( or lines over 80 characters.

James
