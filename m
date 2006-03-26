From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: Re: [PATCH] Move SG_GET_SCSI_ID from sg to scsi
Date: Mon, 27 Mar 2006 01:09:22 +0200
Message-ID: <44271F22.6080400@s5r6.in-berlin.de>
References: <Pine.LNX.4.58.0603262108500.13001@be1.lrz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from einhorn.in-berlin.de ([192.109.42.8]:55464 "EHLO
	einhorn.in-berlin.de") by vger.kernel.org with ESMTP
	id S932177AbWCZXKF (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 26 Mar 2006 18:10:05 -0500
In-Reply-To: <Pine.LNX.4.58.0603262108500.13001@be1.lrz>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Bodo Eggert <7eggert@gmx.de>
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, torvalds@osdl.org

Bodo Eggert wrote:
> Having a SCSI ID is a generic SCSI property,

Most types of SCSI hardware do not have h:c:i:l style IDs like in the 
80's. The lower level drivers only make this tuple up to accomodate 
programming interfaces.
-- 
Stefan Richter
-=====-=-==- --== ==-==
http://arcgraph.de/sr/
