From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH 1/3] arcmsr: Modify maximum outstanding command
Date: Tue, 16 Jul 2013 15:33:56 +0400
Message-ID: <1373974436.2148.47.camel@dabdike>
References: <17ED0DB5E21E4C1EB3CBEDA7F46F7D97@chingDT>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <17ED0DB5E21E4C1EB3CBEDA7F46F7D97@chingDT>
Sender: linux-kernel-owner@vger.kernel.org
To: =?UTF-8?Q?=E9=BB=83=E6=B8=85=E9=9A=86?= <ching2048@areca.com.tw>
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, billion.wu@areca.com.tw
List-Id: linux-scsi@vger.kernel.org

On Tue, 2013-07-16 at 18:22 +0800, =E9=BB=83=E6=B8=85=E9=9A=86 wrote:
> From: Ching<ching2048@areca.com.tw>
>=20
> Modify maximum outstanding command value, notify auto request sense, =
reassign ARC12x4 series to SATA adapter.
> Signed-off-by:Ching<ching2048@areca.com.tw>
> ---

This patch needs to make it to the SCSI mailing list and it didn't.  Yo=
u
can easily check this yourself by either subscribing to the reflector o=
r
looking at some of the archivers like marc:

http://marc.info/?l=3Dlinux-scsi

The reason it got dropped is probably because you have a text/html
attachment.  vger accepts text/plain only.

James
