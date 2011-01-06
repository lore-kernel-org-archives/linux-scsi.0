From: "Darrick J. Wong" <djwong@us.ibm.com>
Subject: Re: how do you try to get the firmware if not exist
Date: Thu, 6 Jan 2011 08:45:20 -0800
Message-ID: <20110106164520.GG27190@tux1.beaverton.ibm.com>
References: <4D2528E2.3090904@oracle.com> <4D252BFB.3090505@oracle.com>
Reply-To: djwong@us.ibm.com
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e5.ny.us.ibm.com ([32.97.182.145]:41636 "EHLO e5.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751811Ab1AFQpW (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 6 Jan 2011 11:45:22 -0500
Received: from d01dlp02.pok.ibm.com (d01dlp02.pok.ibm.com [9.56.224.85])
	by e5.ny.us.ibm.com (8.14.4/8.13.1) with ESMTP id p06GMJYG006950
	for <linux-scsi@vger.kernel.org>; Thu, 6 Jan 2011 11:22:19 -0500
Received: from d01relay06.pok.ibm.com (d01relay06.pok.ibm.com [9.56.227.116])
	by d01dlp02.pok.ibm.com (Postfix) with ESMTP id 0F89D4DE803B
	for <linux-scsi@vger.kernel.org>; Thu,  6 Jan 2011 11:42:30 -0500 (EST)
Received: from d01av02.pok.ibm.com (d01av02.pok.ibm.com [9.56.224.216])
	by d01relay06.pok.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id p06GjKwL1998982
	for <linux-scsi@vger.kernel.org>; Thu, 6 Jan 2011 11:45:20 -0500
Received: from d01av02.pok.ibm.com (loopback [127.0.0.1])
	by d01av02.pok.ibm.com (8.14.4/8.13.1/NCO v10.0 AVout) with ESMTP id p06GjKtG009757
	for <linux-scsi@vger.kernel.org>; Thu, 6 Jan 2011 14:45:20 -0200
Content-Disposition: inline
In-Reply-To: <4D252BFB.3090505@oracle.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Joe Jin <joe.jin@oracle.com>
Cc: DuanZhenzhong <zhenzhong.duan@oracle.com>, James.Bottomley@HansenPartnership.com, Guru Anbalagane <Guru.Anbalagane@oracle.com>, linux-scsi <linux-scsi@vger.kernel.org>

On Thu, Jan 06, 2011 at 10:42:03AM +0800, Joe Jin wrote:
> Hi Jamas, Darrick,
> 
> We find upstream commit 45e6cdf41437c72ed79cee64dc69e7f740511e50 need 
> firmware "sas_addr", and it just used by aic94xx, the question is if
> this is a built-in firmware? if not, would you please help us to get it?

"sas_addr" is a (somewhat wonky) method to override the SAS controller's
address when the driver loads and discovers that the aic94xx controller doesn't
have an assigned SAS address.

(Or at least that's the way it was a few years ago...)

[cc linux-scsi]

--D
