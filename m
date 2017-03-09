From: "Malavali, Giridhar" <Giridhar.Malavali@cavium.com>
Subject: Re: [PATCH v3 00/14] qla2xxx: Bug Fixes and updates for target.
Date: Thu, 9 Mar 2017 21:08:49 +0000
Message-ID: <D4E703FD.8B202%giridhar.malavali@cavium.com>
References: <1487972263-3795-1-git-send-email-himanshu.madhani@cavium.com>
 <1488760974.2808.1.camel@sandisk.com>
 <1488958492.10589.9.camel@haakon3.risingtidesystems.com>
 <1488986438.2599.1.camel@sandisk.com>
 <D4E58D9F.8A5FA%giridhar.malavali@cavium.com>
 <1489030953.10589.40.camel@haakon3.risingtidesystems.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="Windows-1252"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-co1nam03on0083.outbound.protection.outlook.com ([104.47.40.83]:1080
        "EHLO NAM03-CO1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1750914AbdCIVJa (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 9 Mar 2017 16:09:30 -0500
In-Reply-To: <1489030953.10589.40.camel@haakon3.risingtidesystems.com>
Content-Language: en-US
Content-ID: <668EEAC2F1ACA542929FE03ED8425105@namprd07.prod.outlook.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Cc: Bart Van Assche <bart.vanassche@sandisk.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "Madhani, Himanshu" <Himanshu.Madhani@cavium.com>, "target-devel@vger.kernel.org" <target-devel@vger.kernel.org>



On 3/8/17, 7:42 PM, "Nicholas A. Bellinger" <nab@linux-iscsi.org> wrote:

>Hi Giri,
>
>On Wed, 2017-03-08 at 18:30 +0000, Malavali, Giridhar wrote:
>>=20
>> On 3/8/17, 7:20 AM, "Bart Van Assche" <Bart.VanAssche@sandisk.com>
>>wrote:
>>=20
>> >On Tue, 2017-03-07 at 23:34 -0800, Nicholas A. Bellinger wrote:
>> >> Btw, the regression reported here in v2:
>> >>=20
>> >> http://www.spinics.net/lists/target-devel/msg14348.html
>> >>=20
>> >> is completely different from what you've reported here.
>> >
>> >The call traces differ but the root cause is probably the same.
>> >
>> >> It would be useful to explain how you reproduced this, instead of
>>just
>> >> posting backtrace with zero context..?
>> >>=20
>> >> Can we at least identify which patch in this series is causing
>>this..?
>> >>=20
>> >> Also, I assume you are running this on stock v4.11-rc1 with only this
>> >> qla2xxx series applied, and not all of your other stuff, right..?
>> >
>> >The test I ran against v4.11-rc1 + this patch series is to start LIO
>>on a
>> >system equipped with two back-to-back connected QLogic FC HBAs (no
>>switch
>> >inbetween), to load the tcm_qla2xxx driver, to configure LUNs and to
>>wait
>> >until the SCSI stack reports that these LUNs have appeared. What I see
>>in
>> >the lsscsi output with both v2 and v3 of this patch series is that
>>these
>> >LUNs appear briefly and then disappear and that a little bit later the
>> >kernel reports that a hang occurred. Without this patch series the LUNs
>> >are
>> >detected and do not disappear automatically and no hang is reported. I
>> >think the next step is that Cavium verifies whether they can reproduce
>> >this
>> >behavior and if they can reproduce it to run a bisect. BTW, since there
>> >are
>> >login-related patches in this series I wouldn't be surprised if one of
>> >these
>> >patches introduced the regression.
>>=20
>> We generally go through switch. We will try to reproduce with back to
>>back
>> and bisect the patches.
>>=20
>
>Just a heads up given this series mixes bug-fixes with a few other
>miscellaneous improvements, I'd like to get it pushed to Linus with the
>next round of patches no later than -rc3.
>
>If it's beyond -rc3, then the bug-fixes will need to be split out for
>v4.11-rc separate from the other improvements.

Thanks for the heads-up. We are working on Bart reported issue. We are
able to recreate this internally.
We should be able to wrap it up in next few days and send the final
patches. I don=B9t think anything else is outstanding.

=8B Giri

>
