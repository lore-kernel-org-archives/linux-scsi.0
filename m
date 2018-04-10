From: Sasha Levin <Alexander.Levin@microsoft.com>
Subject: Re: [PATCH v3 0/3] Report all request failures again to user space
Date: Tue, 10 Apr 2018 13:49:28 +0000
Message-ID: <DM5PR2101MB10321A8F801C93AAB7E5A36DFBBE0@DM5PR2101MB1032.namprd21.prod.outlook.com>
References: <20180405173301.13186-1-bart.vanassche@wdc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Return-path: <stable-owner@vger.kernel.org>
In-Reply-To: <20180405173301.13186-1-bart.vanassche@wdc.com>
Content-Language: en-US
Sender: stable-owner@vger.kernel.org
To: Sasha Levin <Alexander.Levin@microsoft.com>, Bart Van Assche <bart.vanassche@wdc.com>, "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "stable@vger.kernel.org" <stable@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

Hi,

[This is an automated email]

This commit has been processed by the -stable helper bot and determined
to be a high probability candidate for -stable trees. (score: 19.8603)

The bot has tested the following trees: v4.16.1, v4.15.16, v4.14.33, v4.9.9=
3, v4.4.127.

v4.16.1: Failed to apply! Possible dependencies:
    Unable to calculate

v4.15.16: Build OK!
v4.14.33: Build OK!
v4.9.93: Failed to apply! Possible dependencies:
    2a842acab109 ("block: introduce new block status code type")
    b6800ec54c74 ("Make scsi_result_to_blk_status() recognize CONDITION MET=
")

v4.4.127: Failed to apply! Possible dependencies:
    2a842acab109 ("block: introduce new block status code type")
    b6800ec54c74 ("Make scsi_result_to_blk_status() recognize CONDITION MET=
")


Please let us know if you'd like to have this patch included in a stable tr=
ee.
