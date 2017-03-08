From: "Malavali, Giridhar" <Giridhar.Malavali@cavium.com>
Subject: Re: [PATCH v3 00/14] qla2xxx: Bug Fixes and updates for target.
Date: Wed, 8 Mar 2017 18:30:42 +0000
Message-ID: <D4E58D9F.8A5FA%giridhar.malavali@cavium.com>
References: <1487972263-3795-1-git-send-email-himanshu.madhani@cavium.com>
 <1488760974.2808.1.camel@sandisk.com>
 <1488958492.10589.9.camel@haakon3.risingtidesystems.com>
 <1488986438.2599.1.camel@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="Windows-1252"
Content-Transfer-Encoding: quoted-printable
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <1488986438.2599.1.camel@sandisk.com>
Content-Language: en-US
Content-ID: <55AB335BC4F0754C95D2CEDF9E0CFA90@namprd07.prod.outlook.com>
Sender: target-devel-owner@vger.kernel.org
To: Bart Van Assche <Bart.VanAssche@sandisk.com>, "nab@linux-iscsi.org" <nab@linux-iscsi.org>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "Madhani, Himanshu" <Himanshu.Madhani@cavium.com>, "target-devel@vger.kernel.org" <target-devel@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org



On 3/8/17, 7:20 AM, "Bart Van Assche" <Bart.VanAssche@sandisk.com> wrote:

>On Tue, 2017-03-07 at 23:34 -0800, Nicholas A. Bellinger wrote:
>> Btw, the regression reported here in v2:
>>=20
>> http://www.spinics.net/lists/target-devel/msg14348.html
>>=20
>> is completely different from what you've reported here.
>
>The call traces differ but the root cause is probably the same.
>
>> It would be useful to explain how you reproduced this, instead of just
>> posting backtrace with zero context..?
>>=20
>> Can we at least identify which patch in this series is causing this..?
>>=20
>> Also, I assume you are running this on stock v4.11-rc1 with only this
>> qla2xxx series applied, and not all of your other stuff, right..?
>
>The test I ran against v4.11-rc1 + this patch series is to start LIO on a
>system equipped with two back-to-back connected QLogic FC HBAs (no switch
>inbetween), to load the tcm_qla2xxx driver, to configure LUNs and to wait
>until the SCSI stack reports that these LUNs have appeared. What I see in
>the lsscsi output with both v2 and v3 of this patch series is that these
>LUNs appear briefly and then disappear and that a little bit later the
>kernel reports that a hang occurred. Without this patch series the LUNs
>are
>detected and do not disappear automatically and no hang is reported. I
>think the next step is that Cavium verifies whether they can reproduce
>this
>behavior and if they can reproduce it to run a bisect. BTW, since there
>are
>login-related patches in this series I wouldn't be surprised if one of
>these
>patches introduced the regression.

We generally go through switch. We will try to reproduce with back to back
and bisect the patches.

=8B Giri


>
>Bart.
