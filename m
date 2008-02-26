From: Olaf Kirch <olaf.kirch@oracle.com>
Subject: Re: [ofa-general] [PATCH 2/2] ib fmr pool: flush used clean entries
Date: Tue, 26 Feb 2008 22:58:25 +0100
Message-ID: <200802262258.26536.olaf.kirch@oracle.com>
References: <20080225225330.GA3316@osc.edu> <20080226182753.GF7033@osc.edu> <adazltnwkbz.fsf@cisco.com>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from agminet01.oracle.com ([141.146.126.228]:57309 "EHLO
	agminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1764580AbYBZV7N (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 26 Feb 2008 16:59:13 -0500
In-Reply-To: <adazltnwkbz.fsf@cisco.com>
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: general@lists.openfabrics.org
Cc: Roland Dreier <rdreier@cisco.com>, Pete Wyckoff <pw@osc.edu>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org

On Tuesday 26 February 2008 21:09, Roland Dreier wrote:
> This looks like a really nice approach to me.  Olaf?

Yes, this looks good. I haven't had a chance to test it,
but it looks like the right approach.

Olaf
-- 
Olaf Kirch  |  --- o --- Nous sommes du soleil we love when we play
okir@lst.de |    / | \   sol.dhoop.naytheet.ah kin.ir.samse.qurax
