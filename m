From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: Re: Need some pointers to debug a target hang
Date: Tue, 18 Oct 2016 23:29:27 -0700
Message-ID: <1476858567.8490.101.camel@haakon3.risingtidesystems.com>
References: <20160902141419.h23stppulnyfrnkz@c203.arch.suse.de>
         <1476770275.8490.10.camel@haakon3.risingtidesystems.com>
         <20161018070134.zhyk4ljaxzmvwfs2@linux-x5ow.site>
         <20161018173522.trhoqrcoeof4mn4w@linux-x5ow.site>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.linux-iscsi.org ([67.23.28.174]:57350 "EHLO
        linux-iscsi.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754496AbcJSG33 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 19 Oct 2016 02:29:29 -0400
In-Reply-To: <20161018173522.trhoqrcoeof4mn4w@linux-x5ow.site>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Johannes Thumshirn <jthumshirn@suse.de>
Cc: linux-scsi@vger.kernel.org, target-devel@vger.kernel.org, Robert LeBlanc <robert@leblancnet.us>

On Tue, 2016-10-18 at 19:35 +0200, Johannes Thumshirn wrote:
> On Tue, Oct 18, 2016 at 09:01:34AM +0200, Johannes Thumshirn wrote:
> 
> [...]
> 
> > > 
> > > This is likely the missing SCF_ACK_KREF assignment in >= v4.1.y:
> > > 
> > > http://www.spinics.net/lists/target-devel/msg13530.html
> 
> Sorry to disappoint you but it didn't fix my issue. Is there any debug data I
> can give you, or do you have an advice where I could start looking?
> 
> I have to admit I only tested the patch on our downstream kernel and not the
> upstream kernel, I'll repeat the tests on 4.8 final tomorrow.
> 

Is it possible to generate vmcore to have a look in crash + gdb..?








