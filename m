From: Jean Delvare <khali@linux-fr.org>
Subject: Re: [GIT PATCH] SCSI bug fixes for 2.6.14-rc1
Date: Fri, 23 Sep 2005 22:11:40 +0200
Message-ID: <20050923221140.38d639e3.khali@linux-fr.org>
References: <1127229590.5589.2.camel@mulgrave>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp-105-friday.nerim.net ([62.4.16.105]:35076 "EHLO
	kraid.nerim.net") by vger.kernel.org with ESMTP id S1751200AbVIWUKT
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 23 Sep 2005 16:10:19 -0400
In-Reply-To: <1127229590.5589.2.camel@mulgrave>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org

Hi James,

> James Bottomley:
>   o Fix thread termination for the SCSI error handle

This presumably fixed a problem I was having when reading faulty
CD-ROMs on SCSI drives since 2.6.14-rc1. Thanks!

-- 
Jean Delvare
