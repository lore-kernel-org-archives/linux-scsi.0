Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 73C6AC433ED
	for <linux-scsi@archiver.kernel.org>; Tue,  6 Apr 2021 06:05:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 22F09613C4
	for <linux-scsi@archiver.kernel.org>; Tue,  6 Apr 2021 06:05:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232411AbhDFGFM (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 6 Apr 2021 02:05:12 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:48272 "EHLO
        mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232253AbhDFGFM (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 6 Apr 2021 02:05:12 -0400
Received: from epcas3p1.samsung.com (unknown [182.195.41.19])
        by mailout2.samsung.com (KnoxPortal) with ESMTP id 20210406060502epoutp02e8940bf60419f4666e0b39f87b2516dc~zL6r4IQHZ1049310493epoutp02Y
        for <linux-scsi@vger.kernel.org>; Tue,  6 Apr 2021 06:05:02 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout2.samsung.com 20210406060502epoutp02e8940bf60419f4666e0b39f87b2516dc~zL6r4IQHZ1049310493epoutp02Y
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1617689102;
        bh=HSi0HDIHbSNIU52DqtbwWBBzHpllm5D6oiDlYNQXDb8=;
        h=Subject:Reply-To:From:To:CC:In-Reply-To:Date:References:From;
        b=MloqnU08rK9vPW0CTp/7JTgi0Chg7P64TJ9DLOAu8bcA2BGGZlh0KF52yU9OqtHN8
         3FuRwKdiZTBngtT6mXDQW7VPalYq9+1x1vgFiMq9XDKRFewEH7TCmKXpVnOcDtwh48
         Ynyy/tVn9BhvxyGKLlAJHzXHiFQgxkZII6+0Zf3I=
Received: from epsnrtp4.localdomain (unknown [182.195.42.165]) by
        epcas3p2.samsung.com (KnoxPortal) with ESMTP id
        20210406060502epcas3p2e43618ca2dd66c1d2ec6be02653a0707~zL6rd94mO0694606946epcas3p2t;
        Tue,  6 Apr 2021 06:05:02 +0000 (GMT)
Received: from epcpadp3 (unknown [182.195.40.17]) by epsnrtp4.localdomain
        (Postfix) with ESMTP id 4FDxnp0Csvz4x9Q1; Tue,  6 Apr 2021 06:05:02 +0000
        (GMT)
Mime-Version: 1.0
Subject: RE: Re: [PATCH 1/2] scsi: ufs: Introduce hba performance monitor
 sysfs nodes
Reply-To: daejun7.park@samsung.com
Sender: Daejun Park <daejun7.park@samsung.com>
From:   Daejun Park <daejun7.park@samsung.com>
To:     Can Guo <cang@codeaurora.org>,
        Daejun Park <daejun7.park@samsung.com>
CC:     "asutoshd@codeaurora.org" <asutoshd@codeaurora.org>,
        "nguyenb@codeaurora.org" <nguyenb@codeaurora.org>,
        "hongwus@codeaurora.org" <hongwus@codeaurora.org>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "kernel-team@android.com" <kernel-team@android.com>,
        ALIM AKHTAR <alim.akhtar@samsung.com>,
        Avri Altman <avri.altman@wdc.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Stanley Chu <stanley.chu@mediatek.com>,
        Bean Huo <beanhuo@micron.com>,
        Jaegeuk Kim <jaegeuk@kernel.org>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Kiwoong Kim <kwmad.kim@samsung.com>,
        Satya Tangirala <satyat@google.com>,
        open list <linux-kernel@vger.kernel.org>
X-Priority: 3
X-Content-Kind-Code: NORMAL
In-Reply-To: <e29c3fa0d5ecfd8eb386432008f24e8c@codeaurora.org>
X-CPGS-Detection: blocking_info_exchange
X-Drm-Type: N,general
X-Msg-Generator: Mail
X-Msg-Type: PERSONAL
X-Reply-Demand: N
Message-ID: <1891546521.01617689102000.JavaMail.epsvc@epcpadp3>
Date:   Tue, 06 Apr 2021 14:58:03 +0900
X-CMS-MailID: 20210406055803epcms2p67b21d6e8221738a1d342b3c648b60c94
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: AUTO_CONFIDENTIAL
X-CPGSPASS: Y
X-CPGSPASS: Y
X-Hop-Count: 3
X-CMS-RootMailID: 20210401061611epcas2p279c9303e0e0bf4e2bc5eb1f4ffd84c52
References: <e29c3fa0d5ecfd8eb386432008f24e8c@codeaurora.org>
        <1617257704-1154-2-git-send-email-cang@codeaurora.org>
        <1617257704-1154-1-git-send-email-cang@codeaurora.org>
        <1891546521.01617683881598.JavaMail.epsvc@epcpadp4>
        <CGME20210401061611epcas2p279c9303e0e0bf4e2bc5eb1f4ffd84c52@epcms2p6>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hi Can Guo,
> 
>Hi Daejun,
> 
>On 2021-04-06 12:11, Daejun Park wrote:
>> Hi Can Guo,
>> 
>>> +static ssize_t monitor_enable_store(struct device *dev,
>>> +                                    struct device_attribute *attr,
>>> +                                    const char *buf, size_t count)
>>> +{
>>> +        struct ufs_hba *hba = dev_get_drvdata(dev);
>>> +        unsigned long value, flags;
>>> +
>>> +        if (kstrtoul(buf, 0, &value))
>>> +                return -EINVAL;
>>> +
>>> +        value = !!value;
>>> +        spin_lock_irqsave(hba->host->host_lock, flags);
>>> +        if (value == hba->monitor.enabled)
>>> +                goto out_unlock;
>>> +
>>> +        if (!value) {
>>> +                memset(&hba->monitor, 0, sizeof(hba->monitor));
>>> +        } else {
>>> +                hba->monitor.enabled = true;
>>> +                hba->monitor.enabled_ts = ktime_get();
>> 
>> How about setting lat_max to and lat_min to KTIME_MAX and 0?
> 
>lat_min is already 0. What is the benefit of setting lat_max to 
>KTIME_MAX?
> 
>> I think lat_sum should be 0 at this point.
> 
>lat_sum is already 0 at this point, what is the problem?

Sorry. I misunderstood about resetting monitor values.

> 
>> 
>>> +        }
>>> +
>>> +out_unlock:
>>> +        spin_unlock_irqrestore(hba->host->host_lock, flags);
>>> +        return count;
>>> +}
>> 
>> 
>>> +static void ufshcd_update_monitor(struct ufs_hba *hba, struct 
>>> ufshcd_lrb *lrbp)
>>> +{
>>> +        int dir = ufshcd_monitor_opcode2dir(*lrbp->cmd->cmnd);
>>> +
>>> +        if (dir >= 0 && hba->monitor.nr_queued[dir] > 0) {
>>> +                struct request *req = lrbp->cmd->request;
>>> +                struct ufs_hba_monitor *m = &hba->monitor;
>>> +                ktime_t now, inc, lat;
>>> +
>>> +                now = ktime_get();
>> 
>> How about using lrbp->compl_time_stamp instead of getting new value?
> 
>I am expecting "now" keeps increasing and use it to update 
>m->busy_start_s,
>but if I use lrbp->compl_time_stamp to do that, below line ktime_sub() 
>may
>give me an unexpected value as lrbp->compl_time_stamp may be smaller 
>than
>m->busy_start_ts, because the actual requests are not completed by the 
>device
>in the exact same ordering as the bits set in hba->outstanding_tasks, 
>but driver
>is completing them from bit 0 to bit 31 in ascending order.

lrbp->compl_time_stamp is set just before calling ufshcd_update_monitor().
And I don't think it can be negative value, because ufshcd_send_command()
and __ufshcd_transfer_req_compl() are protected by host lock.

> 
>> 
>>> +                inc = ktime_sub(now, m->busy_start_ts[dir]);
>>> +                m->total_busy[dir] = ktime_add(m->total_busy[dir], 
>>> inc);
>>> +                m->nr_sec_rw[dir] += blk_rq_sectors(req);
>>> +
>>> +                /* Update latencies */
>>> +                m->nr_req[dir]++;
>>> +                lat = ktime_sub(now, lrbp->issue_time_stamp);
>>> +                m->lat_sum[dir] += lat;
>>> +                if (m->lat_max[dir] < lat || !m->lat_max[dir])
>>> +                        m->lat_max[dir] = lat;
>>> +                if (m->lat_min[dir] > lat || !m->lat_min[dir])
>>> +                        m->lat_min[dir] = lat;
>> 
>> This if statement can be shorted, by setting lat_max / lat_min as 
>> default value.
> 
>I don't quite get it, can you show me the code sample?

I think " || !m->lat_max[dir]" can be removed.

                if (m->lat_max[dir] < lat)
                        m->lat_max[dir] = lat;
                if (m->lat_min[dir] > lat)
                        m->lat_min[dir] = lat;
						
Thanks,
Daejun

> 
>Thanks,
>Can Guo
> 
>> 
>>> +
>>> +                m->nr_queued[dir]--;
>>> +                /* Push forward the busy start of monitor */
>>> +                m->busy_start_ts[dir] = now;
>>> +        }
>>> +}
>> 
>> Thanks,
>> Daejun
