From: "Moore, Eric" <Eric.Moore@lsil.com>
Subject: RE: [2.6 patch] drivers/message/fusion/mptfc.c: make 2 functions static
Date: Wed, 25 Jan 2006 09:26:48 -0700
Message-ID: <F331B95B72AFFB4B87467BE1C8E9CF5F1FE9E0@NAMAIL2.ad.lsil.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="US-ASCII"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1750930AbWAYQeo@vger.kernel.org>
Content-class: urn:content-classes:message
Sender: linux-kernel-owner@vger.kernel.org
To: Adrian Bunk <bunk@stusta.de>, Andrew Morton <akpm@osdl.org>
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Tuesday, January 24, 2006 6:01 PM, Adrian Bunk wrote:

> This patch makes two needlessly global functions static.
> 
> 
> Signed-off-by: Adrian Bunk <bunk@stusta.de>
> 
> ---
> 
> This patch was already sent on:
> - 19 Jan 2006
> 
>  drivers/message/fusion/mptfc.c |    6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)
> 


ACK

Signed-off-by: Eric Moore <Eric.Moore@lsil.com>
