From: <Patrick_Boyd@Dell.com>
Subject: RE: [PATCH]mpt fusion: add sysfs attributes to display IOC parameters
Date: Tue, 3 Jul 2007 12:19:34 -0500
Message-ID: <CE7B1A4EF22E704CBFFD9A35BA5C822237029B@ausx3mpc110.aus.amer.dell.com>
References: <20070703130103.GA15841@lsil.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ausc60pc101.us.dell.com ([143.166.85.206]:45831 "EHLO
	ausc60pc101.us.dell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754334AbXGCRUj convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 3 Jul 2007 13:20:39 -0400
Content-class: urn:content-classes:message
In-Reply-To: <20070703130103.GA15841@lsil.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: sathya.prakash@lsi.com, linux-scsi@vger.kernel.org
Cc: eric.moore@lsi.com

>diff -Naurp b/drivers/message/fusion/mptbase.h
a/drivers/message/fusion/mptbase.h
>--- b/drivers/message/fusion/mptbase.h	2007-07-02 16:20:46.000000000
+0530
>+++ a/drivers/message/fusion/mptbase.h	2007-07-03 18:13:28.000000000
+0530
>@@ -78,6 +78,10 @@
> #define MPT_LINUX_VERSION_COMMON	"3.04.05"
> #define MPT_LINUX_PACKAGE_NAME		"@(#)mptlinux-3.04.05"
> #define WHAT_MAGIC_STRING		"@" "(" "#" ")"
>+#define MPT_LINUX_MAJOR_VERSION		3
>+#define MPT_LINUX_MINOR_VERSION		04
>+#define MPT_LINUX_BUILD_VERSION		05
>+#define MPT_LINUX_RELEASE_VERSION	00

You have the version information listed 3 times. Can't you just build
MPT_LINUX_VERSION_COMMON and MPT_LINUX_PACKAGE_NAME?
