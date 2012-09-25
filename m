From: Bart Van Assche <bvanassche@acm.org>
Subject: Re: [PATCH 2/3] libfc: fix lun reset failure bugs in fc_fcp_resp
 handling of FCP_RSP_INFO
Date: Tue, 25 Sep 2012 08:19:25 +0200
Message-ID: <50614CED.1010707@acm.org>
References: <20120924185240.521.22975.stgit@fritz> <20120924185250.521.92611.stgit@fritz>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from [178.239.52.149] ([178.239.52.149]:47615 "EHLO wimaserver10.be"
	rhost-flags-FAIL-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751723Ab2IYGTn (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 25 Sep 2012 02:19:43 -0400
In-Reply-To: <20120924185250.521.92611.stgit@fritz>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Robert Love <robert.w.love@intel.com>
Cc: linux-scsi@vger.kernel.org, Ross Brattain <ross.b.brattain@intel.com>, Frank Zhang <frank_1.zhang@intel.com>, Yi Zou <yi.zou@intel.com>

On 09/24/12 20:52, Robert Love wrote:
> In LUN RESET testing involving NetApp targets, it is observed that LUN
> RESET is failing. The fc_fcp_resp() is not completing the completiong

It looks like there is a typo in the patch description (in the last word 
of the second line) ?

Bart.

