From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH 1/1] ipr: Clear interrupt on croc/crocodile when running with LSI
Date: Wed, 29 Jun 2016 00:48:06 -0400
Message-ID: <yq11t3gtxbt.fsf@sermon.lab.mkp.net>
References: <20160627140941.BC090AE04B@b01ledav005.gho.pok.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <stable-owner@vger.kernel.org>
In-Reply-To: <20160627140941.BC090AE04B@b01ledav005.gho.pok.ibm.com> (Brian
	King's message of "Mon, 27 Jun 2016 09:09:40 -0500")
Sender: stable-owner@vger.kernel.org
To: Brian King <brking@linux.vnet.ibm.com>
Cc: James.Bottomley@HansenPartnership.com, linux-scsi@vger.kernel.org, wenxiong@linux.vnet.ibm.com, stable@vger.kernel.org, benh@kernel.crashing.org
List-Id: linux-scsi@vger.kernel.org

>>>>> "Brian" == Brian King <brking@linux.vnet.ibm.com> writes:

Brian> If we fall back to using LSI on the Croc or Crocodile chip we
Brian> need to clear the interrupt so we don't hang the system.

Applied to 4.7/scsi-fixes.

-- 
Martin K. Petersen	Oracle Linux Engineering
