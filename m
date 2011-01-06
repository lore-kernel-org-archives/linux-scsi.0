From: "Darrick J. Wong" <djwong@us.ibm.com>
Subject: Re: how do you try to get the firmware if not exist
Date: Thu, 6 Jan 2011 08:43:45 -0800
Message-ID: <20110106164345.GF27190@tux1.beaverton.ibm.com>
References: <4D2528E2.3090904@oracle.com>
Reply-To: djwong@us.ibm.com
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e5.ny.us.ibm.com ([32.97.182.145]:41203 "EHLO e5.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751942Ab1AFQnw (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 6 Jan 2011 11:43:52 -0500
Received: from d01dlp01.pok.ibm.com (d01dlp01.pok.ibm.com [9.56.224.56])
	by e5.ny.us.ibm.com (8.14.4/8.13.1) with ESMTP id p06GKTNo004738
	for <linux-scsi@vger.kernel.org>; Thu, 6 Jan 2011 11:20:49 -0500
Received: from d01relay03.pok.ibm.com (d01relay03.pok.ibm.com [9.56.227.235])
	by d01dlp01.pok.ibm.com (Postfix) with ESMTP id 96A9572805F
	for <linux-scsi@vger.kernel.org>; Thu,  6 Jan 2011 11:43:46 -0500 (EST)
Received: from d01av03.pok.ibm.com (d01av03.pok.ibm.com [9.56.224.217])
	by d01relay03.pok.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id p06GhkFB355884
	for <linux-scsi@vger.kernel.org>; Thu, 6 Jan 2011 11:43:46 -0500
Received: from d01av03.pok.ibm.com (loopback [127.0.0.1])
	by d01av03.pok.ibm.com (8.14.4/8.13.1/NCO v10.0 AVout) with ESMTP id p06GhjIQ026806
	for <linux-scsi@vger.kernel.org>; Thu, 6 Jan 2011 14:43:45 -0200
Content-Disposition: inline
In-Reply-To: <4D2528E2.3090904@oracle.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: DuanZhenzhong <zhenzhong.duan@oracle.com>
Cc: James.Bottomley@HansenPartnership.com, Joe Jin <joe.jin@oracle.com>, Guru Anbalagane <Guru.Anbalagane@oracle.com>, linux-scsi <linux-scsi@vger.kernel.org>

On Thu, Jan 06, 2011 at 10:28:50AM +0800, DuanZhenzhong wrote:
> Hi James and djwong,
> 
> How to you try to get the firmware if not exist? thanks

Uh... are you asking how a driver responds when it asks for firmware and
receives nothing in response?  Or are you asking how to find firmware for a
specific driver?

[ccing linux-scsi given the references to aic94xx in the next message...]

--D
