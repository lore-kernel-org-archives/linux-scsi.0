From: Or Gerlitz <ogerlitz@voltaire.com>
Subject: Re: Land iscsi iser performance patches to upstream
Date: Tue, 4 Jan 2011 09:17:43 +0200
Message-ID: <4D22C997.2080704@voltaire.com>
References: <20101216050257.GC1263@parisc-linux.org>	<4D09AE7C.6070708@oracle.com> <4D224E7B.5040704@cs.wisc.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from fwil.voltaire.com ([193.47.165.2]:17094 "EHLO
	Exil2010.voltaire.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750848Ab1ADHRs (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 4 Jan 2011 02:17:48 -0500
In-Reply-To: <4D224E7B.5040704@cs.wisc.edu>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Mike Christie <michaelc@cs.wisc.edu>
Cc: Zhiqi Tao <zhiqi.tao@oracle.com>, linux-scsi@vger.kernel.org

On 1/4/2011 12:32 AM, Mike Christie wrote:
> These patches look ok except for #1. Did you guys have some weird 
> restrictions? Or did you have some weird restrictions but the iser 
> driver handles it (see iser_data_buf_aligned_len related code). I 
> think instead of 0 you want to set the dma alignment to 4K? 

Hi Mike,

Looks like I missed this ~3 years old patch-set, will look into that and 
let you know.

Or.


