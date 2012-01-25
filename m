From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: Re: [PATCH 01/07] lpfc 8.3.29: BSG and User interface fixes
Date: Thu, 26 Jan 2012 07:34:38 +0900
Message-ID: <20120126073003E.fujita.tomonori@lab.ntt.co.jp>
References: <1326921829.32733.10.camel@ogier>
	<4F174603.8060104@cs.wisc.edu>
	<4F1853F1.4020909@emulex.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sh.osrg.net ([192.16.179.4]:37066 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751253Ab2AYWew (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 25 Jan 2012 17:34:52 -0500
In-Reply-To: <4F1853F1.4020909@emulex.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: james.smart@emulex.com
Cc: michaelc@cs.wisc.edu, linux-scsi@vger.kernel.org

On Thu, 19 Jan 2012 12:33:37 -0500
James Smart <james.smart@emulex.com> wrote:

> I'm open to either the scsi_lib helper function, so we have consistent 
> naming.  However, the real answer is to fix bsg to take out references on the 
> object that registers with bsg - so that driver unload is gated on proper 
> unregistration, and no outstanding bsg requests.  Who knows bsg well enough to 
> do this ?

I thought that you worked on such fix. No?
