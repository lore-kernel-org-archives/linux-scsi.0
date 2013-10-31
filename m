From: "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: Subject:  [v3.8][v3.11][Regression] [SCSI] sd: Update WRITE SAME
 heuristics
Date: Wed, 30 Oct 2013 17:02:45 -0700
Message-ID: <52719E25.7000505@zytor.com>
References: <52700AD2.6000703@canonical.com> <5270108E.5040401@itwm.fraunhofer.de> <52715DF5.9040100@canonical.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <52715DF5.9040100@canonical.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Joseph Salisbury <joseph.salisbury@canonical.com>, Bernd Schubert <bernd.schubert@itwm.fraunhofer.de>, "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: JBottomley@Parallels.com, LKML <linux-kernel@vger.kernel.org>, Kamal Mostafa <kamal.mostafa@canonical.com>, linux-scsi@vger.kernel.org, Luis Henriques <luis.henriques@canonical.com>
List-Id: linux-scsi@vger.kernel.org

On 10/30/2013 12:28 PM, Joseph Salisbury wrote:
> Hi Bernd,
> 
> The bug reporter confirms that your patch fixes the bug.  Any chance
> this patch can make it into 3.12?

FWIW, I don't think reverting the WRITE SAME patch is an option -- it
causes serious filesystem failures.

	-hpa
