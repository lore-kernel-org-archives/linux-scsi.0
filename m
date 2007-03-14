From: Mike Christie <michaelc@cs.wisc.edu>
Subject: Re: [PATCH 2/4] scsi: add transport host byte errors
Date: Wed, 14 Mar 2007 15:11:12 -0500
Message-ID: <45F856E0.3000808@cs.wisc.edu>
References: <11739019681346-git-send-email-michaelc@cs.wisc.edu> <11739019693216-git-send-email-michaelc@cs.wisc.edu> <11739019703157-git-send-email-michaelc@cs.wisc.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sabe.cs.wisc.edu ([128.105.6.20]:39582 "EHLO sabe.cs.wisc.edu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933064AbXCNULT (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 14 Mar 2007 16:11:19 -0400
Received: from [20.15.0.7] (c-75-73-64-90.hsd1.mn.comcast.net [75.73.64.90])
	(authenticated bits=0)
	by sabe.cs.wisc.edu (8.13.6/8.13.6) with ESMTP id l2EKBHuu020805
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-scsi@vger.kernel.org>; Wed, 14 Mar 2007 15:11:18 -0500
In-Reply-To: <11739019703157-git-send-email-michaelc@cs.wisc.edu>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

michaelc@cs.wisc.edu wrote:
> The following patches attempt unify what upper layers will see drivers
> like multipath can make a good guess. This relies on drivers being

Oops, I mean to say with the patches upper layers like multipath will
see common behavior from LLDs hooked into transport classes. If the
class/LLD can block a rport/session and recover within
fast_io_fail_tmo/replacement_timeout seconds then multipath would not
see the problem. We will not have some drivers returning errors upwards
and some not and some drivers holding onto errors for until the device
is removed.
