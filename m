From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH v2] scsi: sd: block: Fix regressions in read-only block device handling
Date: Tue, 19 Feb 2019 18:26:20 -0500
Message-ID: <yq1h8czl5r7.fsf@oracle.com>
References: <yq1d0nxuf73.fsf@oracle.com>
        <20190213025717.20057-1-martin.petersen@oracle.com>
        <CACVXFVN9LXodRP8+T_Vd8+5g9K=+hke7ik7N21=heb3csFhh=w@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <stable-owner@vger.kernel.org>
In-Reply-To: <CACVXFVN9LXodRP8+T_Vd8+5g9K=+hke7ik7N21=heb3csFhh=w@mail.gmail.com>
        (Ming Lei's message of "Tue, 19 Feb 2019 09:36:54 +0800")
Sender: stable-owner@vger.kernel.org
To: Ming Lei <tom.leiming@gmail.com>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, Alan Stern <stern@rowland.harvard.edu>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Linux SCSI List <linux-scsi@vger.kernel.org>, linux-block <linux-block@vger.kernel.org>, Jeremy Cline <jeremy@jcline.org>, Oleksii Kurochko <olkuroch@cisco.com>, stable <stable@vger.kernel.org>, linux-usb <linux-usb@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org


Hi Ming,

> From the Bugzilla, looks it is only reported on the "Kingston DT
> Ultimate G3" USB flash drive.

There are several bug reports as a result of the change. It's not at all
uncommon for a device to switch at runtime. Before Jeremy's change we
just didn't see it because the device setting always took precedence and
voided any user setting.

-- 
Martin K. Petersen	Oracle Linux Engineering
