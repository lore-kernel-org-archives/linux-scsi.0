From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH] scsi: smartpqi: Reporting unhandled SCSI errors
Date: Mon, 13 May 2019 20:30:10 -0400
Message-ID: <yq1imudg9nx.fsf@oracle.com>
References: <20190321094928.4198-1-e.velu@criteo.com>
        <CAL2JzuyHb_gfu5Suf3yaMF1883JN1667yhEwpdmoiqYrUTO2YA@mail.gmail.com>
        <SN6PR11MB2767E3FB513853E9666779B9E13B0@SN6PR11MB2767.namprd11.prod.outlook.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <SN6PR11MB2767E3FB513853E9666779B9E13B0@SN6PR11MB2767.namprd11.prod.outlook.com>
        (Don Brace's message of "Wed, 1 May 2019 14:22:11 +0000")
Sender: linux-kernel-owner@vger.kernel.org
To: Don.Brace@microchip.com
Cc: erwanaliasr1@gmail.com, e.velu@criteo.com, don.brace@microsemi.com, jejb@linux.ibm.com, martin.petersen@oracle.com, esc.storagedev@microsemi.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org


>> When a HARDWARE_ERROR is triggered for asc=0x3e, the actual code is
>> only considering the case where ascq=0x1.
>>
>> Following the http://www.t10.org/lists/asc-num.htm#ASC_3E
>> specification, other values may occur like a timeout (ascq=0x2).
>>
>> This patch is about printing an error message when a non-handled
>> message is received.  This could help diagnose a possible
>> miss-behavior of the controller and/or a missing implementation in
>> the Linux Kernel.
>>
>> This patch keeps the exact same error handling but prints a message
>> if an ascq != 1 income.
>>
>> Signed-off-by: Erwan Velu <e.velu@criteo.com>
> Acked-by: Don Brace <don.brace@microsemi.com>

Applied to 5.2/scsi-queue. Thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
