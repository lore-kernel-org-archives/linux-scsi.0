From: Jonathan Nieder <jrnieder@gmail.com>
Subject: Re: scsi: lpfc_scsi: Remove unused variables
Date: Thu, 7 Jun 2012 01:12:56 -0500
Message-ID: <20120607061255.GB3210@burratino>
References: <4FD0434B.7090405@gentoo.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-gg0-f174.google.com ([209.85.161.174]:50931 "EHLO
	mail-gg0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759954Ab2FGGNB (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 7 Jun 2012 02:13:01 -0400
Content-Disposition: inline
In-Reply-To: <4FD0434B.7090405@gentoo.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Richard Yao <ryao@gentoo.org>
Cc: stable@vger.kernel.org, linux-scsi@vger.kernel.org, James Smart <james.smart@emulex.com>

Hi Richard,

Richard Yao wrote:

> This is my first time patch submission. The commit message should
> explain the issue.
>
> commit ba8c7a7a629b736fdc1abceaa3ec49f8820aec08
> Author: Richard Yao <ryao@cs.stonybrook.edu>
> Date:   Thu Jun 7 01:44:31 2012 -0400
>
>     scsi: lpfc_scsi: Remove unused variables
>
>     Kernels built with CONFIG_SCSI_LPFC fail to compile due to the use of
>     -Werror=unused-variable. We solve that by removing some unused
>     variables.

Wouldn't a saner fix be to stop using -Werror=unused-variable, or am I
missing something subtle?

(Since v3.4-rc1~6^2~48 the makefile seems to use plain -Werror, which
seems even worse, since it means any random compiler bug that triggers
a new warning will break the build.)

Thanks and hope that helps,
Jonathan
