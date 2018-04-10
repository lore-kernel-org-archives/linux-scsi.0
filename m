From: Sasha Levin <Alexander.Levin@microsoft.com>
Subject: Re: [PATCH v1 03/15] mpt3sas: Add sanity checks for scsi tracker
 before  accessing it.
Date: Tue, 10 Apr 2018 13:49:18 +0000
Message-ID: <DM5PR2101MB1032206651FBFD0BB9C33A46FBBE0@DM5PR2101MB1032.namprd21.prod.outlook.com>
References: <1522943197-5408-4-git-send-email-chaitra.basappa@broadcom.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Return-path: <stable-owner@vger.kernel.org>
In-Reply-To: <1522943197-5408-4-git-send-email-chaitra.basappa@broadcom.com>
Content-Language: en-US
Sender: stable-owner@vger.kernel.org
To: Sasha Levin <Alexander.Levin@microsoft.com>, Chaitra P B <chaitra.basappa@broadcom.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
Cc: "Sathya.Prakash@broadcom.com" <Sathya.Prakash@broadcom.com>, "sreekanth.reddy@broadcom.com" <sreekanth.reddy@broadcom.com>, "stable@vger.kernel.org" <stable@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

Hi,

[This is an automated email]

This commit has been processed by the -stable helper bot and determined
to be a high probability candidate for -stable trees. (score: 28.7865)

The bot has tested the following trees: v4.16.1, v4.15.16, v4.14.33, v4.9.9=
3, v4.4.127.

v4.16.1: Build OK!
v4.15.16: Failed to apply! Possible dependencies:
    dbec4c9040ed ("scsi: mpt3sas: lockless command submission")

v4.14.33: Failed to apply! Possible dependencies:
    dbec4c9040ed ("scsi: mpt3sas: lockless command submission")

v4.9.93: Failed to apply! Possible dependencies:
    dbec4c9040ed ("scsi: mpt3sas: lockless command submission")

v4.4.127: Failed to apply! Possible dependencies:
    dbec4c9040ed ("scsi: mpt3sas: lockless command submission")


Please let us know if you'd like to have this patch included in a stable tr=
ee.
