From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH 1/3] arcmsr: Support Areca new SATA Raid Adapter
 ARC1214/1224/1264/1284
Date: Mon, 26 Aug 2013 14:18:38 +0400
Message-ID: <1377512318.20958.5.camel@dabdike>
References: <7A2818CC441F4BCE96D3B1E70CC3D76B@chingDT>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <7A2818CC441F4BCE96D3B1E70CC3D76B@chingDT>
Sender: linux-kernel-owner@vger.kernel.org
To: =?UTF-8?Q?=E9=BB=83=E6=B8=85=E9=9A=86?= <ching2048@areca.com.tw>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>, billion@areca.com.tw
List-Id: linux-scsi@vger.kernel.org

On Mon, 2013-08-26 at 12:14 +0800, =E9=BB=83=E6=B8=85=E9=9A=86 wrote:
>  From: Ching <ching2048@areca.com.tw>
>=20
> Support Areca new SATA Raid adapter ARC1214/1224/1264/1284.
> Modify maximum outstanding command number, notify command complete wi=
th auto
> request sense
> Signed-off-by: Ching  <ching2048@areca.com.tw>

Checkpatch really doesn't like this:

total: 1 errors, 173 warnings, 7131 lines checked

I fixed up the error and the few relevant warnings.  I don't really car=
e
about the lines over 80 characters.  However, if you're going to have
long lines, don't split strings (another checkpatch complaint).  I'd
also like to see the spurious braces removed in a later patch, please.
The prinks without a KERN_ also need fixing.

James
