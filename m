Return-Path: <SRS0=uqxd=XG=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CC0A9C49ED6
	for <linux-scsi@archiver.kernel.org>; Wed, 11 Sep 2019 21:18:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A42682082C
	for <linux-scsi@archiver.kernel.org>; Wed, 11 Sep 2019 21:18:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730013AbfIKVS1 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 11 Sep 2019 17:18:27 -0400
Received: from bhuna.collabora.co.uk ([46.235.227.227]:60934 "EHLO
        bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729867AbfIKVS1 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 11 Sep 2019 17:18:27 -0400
Received: from [127.0.0.1] (localhost [127.0.0.1])
        (Authenticated sender: tonyk)
        with ESMTPSA id D3E8128D55D
Subject: Re: [PATCH 1/3] docs: scsi: fix typo
To:     Joe Perches <joe@perches.com>, linux-kernel@vger.kernel.org,
        linux-scsi@vger.kernel.org, linux-doc@vger.kernel.org
Cc:     corbet@lwn.net, kernel@collabora.com, krisman@collabora.com,
        jejb@linux.ibm.com, martin.petersen@oracle.com
References: <20190911203735.1332398-1-andrealmeid@collabora.com>
 <51d9807c5881b467e8bb549eecf04c5cb168f0c1.camel@perches.com>
From:   =?UTF-8?Q?Andr=c3=a9_Almeida?= <andrealmeid@collabora.com>
Message-ID: <73b5fd0f-c181-3aa2-1752-b36fbeecf2ed@collabora.com>
Date:   Wed, 11 Sep 2019 18:17:18 -0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.0
MIME-Version: 1.0
In-Reply-To: <51d9807c5881b467e8bb549eecf04c5cb168f0c1.camel@perches.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 9/11/19 6:10 PM, Joe Perches wrote:
> On Wed, 2019-09-11 at 17:37 -0300, André Almeida wrote:
>> "Busses" is the third person conjugation of verb "to buss" in the
>> present tense. "Buses" is the plural of bus, as in "serial bus".
> 
> busses and buses are both acceptable plurals of bus
> 
> https://www.dictionary.com/browse/bus
> 

Thanks for the feedback! I used this reference[1] for writing my commit
message, but I believe we can leave the way it is now.

Thanks,
	André

[1] https://writingexplained.org/buses-or-busses-difference

