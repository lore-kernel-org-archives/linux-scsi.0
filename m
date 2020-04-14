Return-Path: <SRS0=dx4r=56=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 067DDC2BA2B
	for <linux-scsi@archiver.kernel.org>; Tue, 14 Apr 2020 02:49:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D52742072A
	for <linux-scsi@archiver.kernel.org>; Tue, 14 Apr 2020 02:49:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404220AbgDNCt6 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 13 Apr 2020 22:49:58 -0400
Received: from smtp.infotech.no ([82.134.31.41]:42891 "EHLO smtp.infotech.no"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727870AbgDNCt5 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 13 Apr 2020 22:49:57 -0400
Received: from localhost (localhost [127.0.0.1])
        by smtp.infotech.no (Postfix) with ESMTP id 2A77E20425A;
        Tue, 14 Apr 2020 04:49:56 +0200 (CEST)
X-Virus-Scanned: by amavisd-new-2.6.6 (20110518) (Debian) at infotech.no
Received: from smtp.infotech.no ([127.0.0.1])
        by localhost (smtp.infotech.no [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id o06JtJrDEneZ; Tue, 14 Apr 2020 04:49:50 +0200 (CEST)
Received: from [192.168.48.23] (host-23-251-188-50.dyn.295.ca [23.251.188.50])
        by smtp.infotech.no (Postfix) with ESMTPA id A8B4C20414B;
        Tue, 14 Apr 2020 04:49:49 +0200 (CEST)
Reply-To: dgilbert@interlog.com
Subject: Re: [PATCH v4 00/14] scsi_debug: host managed ZBC + doublestore
To:     "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, jejb@linux.vnet.ibm.com, hare@suse.de,
        Damien.LeMoal@wdc.com
References: <20200225062351.21267-1-dgilbert@interlog.com>
 <yq1mu7fug6k.fsf@oracle.com>
From:   Douglas Gilbert <dgilbert@interlog.com>
Message-ID: <4bbcf1f6-1dc1-ccaf-c39a-0e2a98f0fbdf@interlog.com>
Date:   Mon, 13 Apr 2020 22:49:39 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
In-Reply-To: <yq1mu7fug6k.fsf@oracle.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-CA
Content-Transfer-Encoding: 7bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2020-04-13 7:19 p.m., Martin K. Petersen wrote:

in response to the cover letter of a patchset sent: 2020-02-25, 1:23 a.m.
which is 7 weeks ago!

> Evening Doug!
> 
>> The major addition is support for host-managed ZBC devices.  The bulk
>> of the work in this area was done by Damien Le Moal.  It allows ZBC
>> devices with a mix of conventional and "sequential write required"
>> zones to be specified.
> 
> [...]
> 
>> The lower numbered patches in this set contain various measures to
>> improve the speed and usefulness of this driver.  It is being used to
>> test the rewrite of the SCSI generic (sg) driver which is still
>> underway.
> 
> These really should be separate series. One for the ZBC stuff (which
> generally looks OK), one for the backing store enablement, and maybe one
> for the general improvements that do not have other dependencies.

But other things such as the "ZBC stuff" have dependencies on those
general improvements in obvious (i.e. seen by git) and subtle ways.

> It's much more manageable for reviewers when things come in smaller
> batches. Once a posted series has been merged, you can rebase your
> working tree and submit the next batch of 5-10 patches.

I believe you overvalue the review process, it is mainly window
dressing, unevenly applied.

Doug Gilbert


