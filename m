From: Mike Anderson <andmike@us.ibm.com>
Subject: Re: scsi_do_req documentation?
Date: Thu, 22 Aug 2002 09:58:38 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20020822165838.GB1336@beaverton.ibm.com>
References: <3D616EF2.3060905@deming-os.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <3D616EF2.3060905@deming-os.org>
List-Id: linux-scsi@vger.kernel.org
To: Russell Lewis <spamhole-2001-07-16@deming-os.org>
Cc: linux-scsi@vger.kernel.org

Russell,
	I do not know of any documentation on scsi_do_req. If you have
	not already found your answer take a look at sg.c as it uses
	scsi_do_req.

	The short answer to your question is that your done will be
	called from scsi_finish_command which is called from
	scsi_softirq.

	The scsi_do_req caller is responsible for cleaning up the
	Scsi_Cmnd by calling scsi_release_request in there done
	function.

-Mike
Russell Lewis [spamhole-2001-07-16@deming-os.org] wrote:
> Can somebody give me a link to good documentation of scsi_do_req?  I'm 
> looking especially for details on how my done function will be called 
> (interrupt context or not?) and who's responsible for cleaning up the 
> Scsi_Cmnd structure.

-- 
Michael Anderson
andmike@us.ibm.com

