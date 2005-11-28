From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: Re: [PATCH 6/11]  lpfc 8.1.1 : Fixes to error handlers
Date: Mon, 28 Nov 2005 20:02:45 +0100
Message-ID: <438B5455.3050803@s5r6.in-berlin.de>
References: <9BB4DECD4CFE6D43AA8EA8D768ED51C2276C4A@xbl3.emulex.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from einhorn.in-berlin.de ([192.109.42.8]:32930 "EHLO
	einhorn.in-berlin.de") by vger.kernel.org with ESMTP
	id S932177AbVK1TDX (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 28 Nov 2005 14:03:23 -0500
In-Reply-To: <9BB4DECD4CFE6D43AA8EA8D768ED51C2276C4A@xbl3.emulex.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: James.Smart@Emulex.Com

James Smart wrote:
> - Serialize EH calls and block requests when EH function is running.

Is this necessary? From what I understood from docs or comments, there 
is nothing enqueued while an EH is run. (Furthermore, EHs are not 
concurrent per host.) Or am I mistaken?
-- 
Stefan Richter
-=====-=-=-= =-== ===--
http://arcgraph.de/sr/
