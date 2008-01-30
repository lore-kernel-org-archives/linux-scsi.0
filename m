From: Keith Hopkins <vger@hopnet.net>
Subject: Re: aic94xx: failing on high load (another data point)
Date: Wed, 30 Jan 2008 18:59:34 +0800
Message-ID: <47A05896.40900@hopnet.net>
References: <479FB3ED.3080401@hopnet.net> <20080130091403.GA14887@alaris.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from [221.218.196.247] ([221.218.196.247]:53797 "EHLO
	mail.hopnet.net" rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1752665AbYA3Ld6 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 30 Jan 2008 06:33:58 -0500
In-Reply-To: <20080130091403.GA14887@alaris.suse.cz>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jan Sembera <jsembera@suse.cz>
Cc: linux-scsi@vger.kernel.org

On 01/30/2008 05:14 PM, Jan Sembera wrote:
> 
> 	We tried firmware versions V28, V30, and even V32 that is, as
> far as I know, not yet available on adaptec website. All of them were
> unfortunately displaying exactly the same behaviour :-(. Did you get your
> SAS controller working? And if so, with which firmware was that?
> 

V28.  My controller functions well with a single drive (low-medium load).  Unfortunately, all attempts to get the mirrors in sync fail and usually hang the whole box.

--Keith
