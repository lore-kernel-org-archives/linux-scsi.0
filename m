From: Tyrel Datwyler <tyreld@linux.vnet.ibm.com>
Subject: Re: [PATCH 0/2] ibmvfc: FC-TAPE Support
Date: Thu, 11 Aug 2016 13:37:24 -0700
Message-ID: <57ACE204.7000106@linux.vnet.ibm.com>
References: <1470260213-19087-1-git-send-email-tyreld@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1470260213-19087-1-git-send-email-tyreld@linux.vnet.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Tyrel Datwyler <tyreld@linux.vnet.ibm.com>, james.bottomley@hansenpartnership.com
Cc: martin.petersen@oracle.com, linux-scsi@vger.kernel.org, linuxppc-dev@lists.ozlabs.org, brking@linux.vnet.ibm.com, nfont@linux.vnet.ibm.com, linux-kernel@vger.kernel.org, mpe@ellerman.id.au
List-Id: linux-scsi@vger.kernel.org

On 08/03/2016 02:36 PM, Tyrel Datwyler wrote:
> This patchset introduces optional FC-TAPE/FC Class 3 Error Recovery to the
> ibmvfc client driver.
> 
> Tyrel Datwyler (2):
>   ibmvfc: Set READ FCP_XFER_READY DISABLED bit in PRLI
>   ibmvfc: add FC Class 3 Error Recovery support
> 
>  drivers/scsi/ibmvscsi/ibmvfc.c | 11 +++++++++++
>  drivers/scsi/ibmvscsi/ibmvfc.h |  1 +
>  2 files changed, 12 insertions(+)
> 

ping?
