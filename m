From: Laurence Oberman <loberman@redhat.com>
Subject: Re: Patch: add to Documentation/scsi for scsi_dev_flags and command
 line passing
Date: Wed, 18 Oct 2017 13:51:03 -0400
Message-ID: <CAFfF4qu+K8kSq6f7vQhhdXsYCxikWJa51Lw3U9kVtvcoKenKkA@mail.gmail.com>
References: <1508346789.13599.2.camel@redhat.com> <3d702bd5-b96e-3f5b-482b-b2c36278c219@infradead.org>
 <CAFfF4qua-gutNTT+s+HuxrgS_B8sV5J+8x0-VbrYwObd5mN4bQ@mail.gmail.com> <4717328f-24b2-9273-c41c-a02f27e8b921@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-qt0-f196.google.com ([209.85.216.196]:48332 "EHLO
        mail-qt0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750775AbdJRRvE (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 18 Oct 2017 13:51:04 -0400
Received: by mail-qt0-f196.google.com with SMTP id f8so11304999qta.5
        for <linux-scsi@vger.kernel.org>; Wed, 18 Oct 2017 10:51:04 -0700 (PDT)
In-Reply-To: <4717328f-24b2-9273-c41c-a02f27e8b921@infradead.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Randy Dunlap <rdunlap@infradead.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, "Martin K. Petersen" <martin.petersen@oracle.com>

Indeed it was Evolution and then linux-scsi rejected my fix.

Trying again, for some reason it thought I had html

Signed-off-by: Laurence Oberman <loberman@redhat.com>

--- a/Documentation/scsi/scsi-parameters.txt
+++ b/Documentation/scsi/scsi-parameters.txt
@@ -116,3 +116,11 @@ parameters may be changed at runtime by the command

  wd33c93= [HW,SCSI]
  See header of drivers/scsi/wd33c93.c.
+
+Additional notes on passing parameters on the command line:
+
+It's not intuitively obvious how to pass certain parameters on the boot line.
+For parameters such as scsi_dev_flags, you need to pass to the scsi_mod as
+follows.
+On kernel line add scsi_mod.dev_flags=LIO-ORG:thin2:0x8000000
+

On Wed, Oct 18, 2017 at 1:46 PM, Randy Dunlap <rdunlap@infradead.org> wrote:
> On 10/18/17 10:28, Laurence Oberman wrote:
>> I just noticed that
>> Was taken straight out of git after changing the Doc file.
>> Let me see why git did that
>>
>
> It's more likely that Evolution did it.
>
>>
>> On Wed, Oct 18, 2017 at 1:25 PM, Randy Dunlap <rdunlap@infradead.org <mailto:rdunlap@infradead.org>> wrote:
>>
>>     On 10/18/17 10:13, Laurence Oberman wrote:
>>     > Tired of forgetting about this so documented it for others so they also
>>     > don't spend unnecessary time figuring this out.
>>     >
>>     > Signed-off-by: Laurence Oberman <loberman@redhat.com <mailto:loberman@redhat.com>>
>>     >
>>     > diff --git a/Documentation/scsi/scsi-parameters.txt
>>     > b/Documentation/scsi/scsi-parameters.txt
>>     > index 8477655..c9e9ce8 100644
>>     > --- a/Documentation/scsi/scsi-parameters.txt
>>     > +++ b/Documentation/scsi/scsi-parameters.txt
>>     > @@ -116,3 +116,9 @@ parameters may be changed at runtime by the command
>>     >
>>     >       wd33c93=        [HW,SCSI]
>>     >                       See header of drivers/scsi/wd33c93.c.
>>     > +
>>     > +Additional notes on passing parameters on the command line.
>>
>>                                                              line:
>>
>>     > +Its not intuitively obvious how to pass certain parameters on the boot
>>
>>        It's
>>
>>     > line.
>>     > +For parameters such as scsi_dev_flags, you need to pass to the
>>     > scsi_mod as follows
>>
>>                as follows:
>>
>>     > +scsi_mod.dev_flags=LIO-ORG:thin2:0x80000000
>>     > +
>>     > --
>>     > 1.8.3.1
>>
>>
>>     Also the patch has some weird line breaks.
>>
>>
>>     --
>>     ~Randy
>>
>>
>
>
> --
> ~Randy
