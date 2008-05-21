From: Mike Christie <michaelc@cs.wisc.edu>
Subject: Re: iscsi update for 2.6.27
Date: Wed, 21 May 2008 16:06:08 -0500
Message-ID: <48348EC0.5080905@cs.wisc.edu>
References: <1211403260-5487-1-git-send-email-michaelc@cs.wisc.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:53942 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759039AbYEUVGN (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 21 May 2008 17:06:13 -0400
Received: from int-mx1.corp.redhat.com (int-mx1.corp.redhat.com [172.16.52.254])
	by mx1.redhat.com (8.13.8/8.13.8) with ESMTP id m4LL6CjD022202
	for <linux-scsi@vger.kernel.org>; Wed, 21 May 2008 17:06:12 -0400
Received: from pobox.corp.redhat.com (pobox.corp.redhat.com [10.11.255.20])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m4LL6AWd024995
	for <linux-scsi@vger.kernel.org>; Wed, 21 May 2008 17:06:11 -0400
Received: from [10.11.14.6] (vpn-14-6.rdu.redhat.com [10.11.14.6])
	by pobox.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m4LL69Xk015759
	for <linux-scsi@vger.kernel.org>; Wed, 21 May 2008 17:06:10 -0400
In-Reply-To: <1211403260-5487-1-git-send-email-michaelc@cs.wisc.edu>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

michaelc@cs.wisc.edu wrote:
> This also includes from cleanup patches from Harvey Harrison. It does
> include the patch from Boaz since I goofed and forgot that we were

This should say it does _not_ include the patch from boaz.


> going to cleanup the iscsi_ecdb_ahdr 260 hardcoding usage and Boaz and James
> are discussing where to define that. That can go in later when Boaz is
> ready and those issues are resolved.
