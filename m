Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9B492C28D13
	for <linux-scsi@archiver.kernel.org>; Mon, 22 Aug 2022 21:45:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238324AbiHVVpR (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 22 Aug 2022 17:45:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41212 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238228AbiHVVpP (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 22 Aug 2022 17:45:15 -0400
Received: from mail-io1-f71.google.com (mail-io1-f71.google.com [209.85.166.71])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 73026564E8
        for <linux-scsi@vger.kernel.org>; Mon, 22 Aug 2022 14:45:14 -0700 (PDT)
Received: by mail-io1-f71.google.com with SMTP id z4-20020a6b0a04000000b006887f66dcf3so6353975ioi.18
        for <linux-scsi@vger.kernel.org>; Mon, 22 Aug 2022 14:45:14 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=to:from:subject:message-id:in-reply-to:date:mime-version
         :x-gm-message-state:from:to:cc;
        bh=lvDv3fY56hvUDqlCuuOa5TsCeohcojRJoetuEGrJWa8=;
        b=Fr0mEZIA+jjTHQ/pYku9E4u/vTGTFJ9fuXhS44qIQcIMwa9+9Q88QUAcOZZax7BFfD
         rDBHxJ105xHW5fZv6zL5QqSIQEcKsxtcO0VnppJZfAuHx4KLWcoGl7zTJZxSy0HsldJW
         wsf+gRc9xhmTDNu0XgQ6DWAgt7tRzLD30Qx03Q64IppT9VWYH2LzepSf7loFiQFqqtbN
         xNzZeoQnkl1rSKztyuUmrYL71ausyc4M1uxySoMiRnDIIv0KBTD0l1+xcNWlR2upoh1n
         ZGXZxcfSG6SfLJVi+RFJhDum1N1D8vxVvMff1H2ln1ktalWtK16v6mVXfuV+q17xTM6E
         BoSg==
X-Gm-Message-State: ACgBeo2f+59B5uBe0UJZbIbPLe7+d/PTCvMeHFvwnNakxIP9BV1b21Ex
        x5/7pFomfIlIHkTdLMD+MsPU0aA8av+LZuLUhUHTFGJIfUzJ
X-Google-Smtp-Source: AA6agR4GSvl30pCUuBFcCvh7OLuPyo1OmiddCog13EloqJ5x5ueeFfVOzeBAN4jTBuX2js5urmqVvfypiZhWEPbz3OyDt+YvHOrE
MIME-Version: 1.0
X-Received: by 2002:a05:6602:29d1:b0:669:428e:8c59 with SMTP id
 z17-20020a05660229d100b00669428e8c59mr9434201ioq.85.1661204713833; Mon, 22
 Aug 2022 14:45:13 -0700 (PDT)
Date:   Mon, 22 Aug 2022 14:45:13 -0700
In-Reply-To: <3eb3867b-9bd5-3de0-b00e-de77d724636e@acm.org>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000de0b4205e6db5ce8@google.com>
Subject: Re: [syzbot] INFO: task hung in scsi_remove_host
From:   syzbot <syzbot+bafeb834708b1bb750bc@syzkaller.appspotmail.com>
To:     bvanassche@acm.org, jejb@linux.ibm.com,
        linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org,
        martin.petersen@oracle.com, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hello,

syzbot has tested the proposed patch and the reproducer did not trigger any issue:

Reported-and-tested-by: syzbot+bafeb834708b1bb750bc@syzkaller.appspotmail.com

Tested on:

commit:         0fe8e010 scsi: core: Revert "Make sure that targets ou..
git tree:       https://github.com/bvanassche/linux.git scsi-for-next
console output: https://syzkaller.appspot.com/x/log.txt?x=100c7465080000
kernel config:  https://syzkaller.appspot.com/x/.config?x=312be25752c7fe30
dashboard link: https://syzkaller.appspot.com/bug?extid=bafeb834708b1bb750bc
compiler:       gcc (Debian 10.2.1-6) 10.2.1 20210110, GNU ld (GNU Binutils for Debian) 2.35.2

Note: no patches were applied.
Note: testing is done by a robot and is best-effort only.
