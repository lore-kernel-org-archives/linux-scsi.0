From: Dave Jones <davej@redhat.com>
Subject: Re: [PATCH] qla2xxx: support for multi- queue adapter
Date: Tue, 16 Dec 2008 14:47:45 -0500
Message-ID: <20081216194745.GA20277@redhat.com>
References: <alpine.OSX.1.00.0812091525020.9629@ac-mac.local>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.redhat.com ([66.187.237.31]:47192 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752490AbYLPTsS (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 16 Dec 2008 14:48:18 -0500
Content-Disposition: inline
In-Reply-To: <alpine.OSX.1.00.0812091525020.9629@ac-mac.local>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Anirban Chakraborty <anirban.chakraborty@qlogic.com>
Cc: James.Bottomley@HansenPartnership.com, linux-scsi@vger.kernel.org, linux-driver@qlogic.com

On Tue, Dec 09, 2008 at 04:45:39PM -0800, Anirban Chakraborty wrote:
  > +	memset(vha->req_ques, sizeof(vha->req_ques) * QLA_MAX_HOST_QUES, 0);

ITYM

+       memset(vha->req_ques, 0, sizeof(vha->req_ques) * QLA_MAX_HOST_QUES);

        Dave
 
-- 
http://www.codemonkey.org.uk
