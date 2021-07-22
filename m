Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 500D8C4338F
	for <linux-scsi@archiver.kernel.org>; Thu, 22 Jul 2021 19:21:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 23B7460EB8
	for <linux-scsi@archiver.kernel.org>; Thu, 22 Jul 2021 19:21:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230153AbhGVSlD (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 22 Jul 2021 14:41:03 -0400
Received: from verein.lst.de ([213.95.11.211]:35750 "EHLO verein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229556AbhGVSlD (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 22 Jul 2021 14:41:03 -0400
Received: by verein.lst.de (Postfix, from userid 2407)
        id 9FF9B67373; Thu, 22 Jul 2021 21:21:36 +0200 (CEST)
Date:   Thu, 22 Jul 2021 21:21:36 +0200
From:   Christoph Hellwig <hch@lst.de>
To:     Bart Van Assche <bvanassche@acm.org>
Cc:     Christoph Hellwig <hch@lst.de>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Jens Axboe <axboe@kernel.dk>,
        FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>,
        Doug Gilbert <dgilbert@interlog.com>,
        Kai =?iso-8859-1?Q?M=E4kisara?= <Kai.Makisara@kolumbus.fi>,
        linux-block@vger.kernel.org, linux-scsi@vger.kernel.org
Subject: Re: [PATCH 20/24] scsi: remove a very misleading comment
Message-ID: <20210722192136.GC15240@lst.de>
References: <20210712054816.4147559-1-hch@lst.de> <20210712054816.4147559-21-hch@lst.de> <47a8e460-125e-6219-5ae6-d3c601e72350@acm.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <47a8e460-125e-6219-5ae6-d3c601e72350@acm.org>
User-Agent: Mutt/1.5.17 (2007-11-01)
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Thu, Jul 22, 2021 at 10:52:44AM -0700, Bart Van Assche wrote:
>> - * routines know the command size based on the opcode decode.
>> - *
>> - * The output area is then filled in starting from the command byte.
>> - */
>> -
>>   static int ioctl_internal_command(struct scsi_device *sdev, char *cmd,
>>   				  int timeout, int retries)
>>   {
>
> How about adding a comment that explains what this function does? How about 
> declaring 'cmd' const and adding a comment that it is a pointer to a SCSI 
> CDB? How about documenting the unit of 'timeout'?

Not sure there is much of a point for a static function in (pun intended)
fairly static code.
