From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH v3 01/16] lpfc: Correct WQ creation for pagesize
Date: Tue, 07 Mar 2017 20:26:43 -0500
Message-ID: <yq1h934imng.fsf@oracle.com>
References: <58a0d919.08BhoypOnvRSLIqV%jsmart2021@gmail.com>
        <6a197069-2f10-6df1-4cf1-1a62808c8903@linux.vnet.ibm.com>
        <yq1tw75kbdn.fsf@oracle.com>
        <7c6d6f3b-330c-ea6f-ad3f-65479354c94d@linux.vnet.ibm.com>
        <20170307195704.GB25619@kroah.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <stable-owner@vger.kernel.org>
In-Reply-To: <20170307195704.GB25619@kroah.com> (Greg KH's message of "Tue, 7
        Mar 2017 20:57:04 +0100")
Sender: stable-owner@vger.kernel.org
To: Greg KH <gregkh@linuxfoundation.org>
Cc: Mauricio Faria de Oliveira <mauricfo@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, stable@vger.kernel.org, James Smart <jsmart2021@gmail.com>, linux-scsi@vger.kernel.org, linux-nvme@lists.infradead.org, sagi@grimberg.me
List-Id: linux-scsi@vger.kernel.org

>>>>> "Greg" == Greg KH <gregkh@linuxfoundation.org> writes:

Greg,

>> Can this commit be included on stable v4.4+ , please? (in Linus tree)
>> 
>> 8ea73db486cda442f0671f4bc9c03a76be398a28 "scsi: lpfc: Correct WQ
>> creation for pagesize"

Greg> I need an ack from a scsi maintainer that this is an ok thing to
Greg> do before I can do so.

It's fine with me. This was merged as part of a bigger driver update.
And as a result, the patch in question wasn't tagged as a fix/stable
candidate.

-- 
Martin K. Petersen	Oracle Linux Engineering
