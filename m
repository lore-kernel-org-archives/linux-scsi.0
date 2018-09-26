From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH v4] scsi: ufs: Make sysfs attributes writable
Date: Tue, 25 Sep 2018 21:08:09 -0400
Message-ID: <yq1h8idgj5y.fsf@oracle.com>
References: <20180808224454.243790-1-evgreen@chromium.org>
        <6dd8a547-7260-09b8-9096-8a1564b08e70@intel.com>
        <8fd05b2d-fa48-78af-6f1c-7e485c1008f6@intel.com>
        <CAD=FV=W7h_3LwV-P5_E58-3qOo7Y-yQDTDfSLoU1+3c_6ZF0cg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CAD=FV=W7h_3LwV-P5_E58-3qOo7Y-yQDTDfSLoU1+3c_6ZF0cg@mail.gmail.com>
        (Doug Anderson's message of "Tue, 25 Sep 2018 11:40:54 -0700")
Sender: linux-kernel-owner@vger.kernel.org
To: Doug Anderson <dianders@chromium.org>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, Evan Green <evgreen@chromium.org>, vinholikatti@gmail.com, jejb@linux.vnet.ibm.com, stanislav.nijnikov@wdc.com, linux-scsi@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>, Bart.VanAssche@wdc.com, Adrian Hunter <adrian.hunter@intel.com>
List-Id: linux-scsi@vger.kernel.org


Doug,

> I came across this patch and Evan's other one and noticed that they
> haven't been applied though a batch of other SCSI patches for 4.20
> were applied about a week ago.  Martin: is there something about these
> patches that needs to change before they can land?

I have simply been awaiting some sort of consensus on the various
competing approaches. Lots of patches posted with tiny incremental fixes
but very little discussion about the merits of one over the other.

-- 
Martin K. Petersen	Oracle Linux Engineering
