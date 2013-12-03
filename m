From: One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>
Subject: Re: [PATCH/RESEND v2 1/2] Hard disk resume time optimization,
 asynchronous ata_port_resume
Date: Tue, 3 Dec 2013 16:35:58 +0000
Message-ID: <20131203163558.354e2efd@alan.etchedpixels.co.uk>
References: <20131203162735.GB12554@linux.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <20131203162735.GB12554@linux.intel.com>
Sender: linux-ide-owner@vger.kernel.org
To: todd.e.brandt@linux.intel.com
Cc: JBottomley@parallels.com, linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org, tj@kernel.org
List-Id: linux-scsi@vger.kernel.org

> thus allowing the UI to come online sooner. There may be a short period after 
> resume where the disks are still spinning up in the background, but the user 
> shouldn't notice since the OS can function with the data left in RAM.

I wonder how many marginal power supplies this will find 8)

I still think it's the right thing to do. In the SCSI world a bit more
caution was needed however.

Alan
