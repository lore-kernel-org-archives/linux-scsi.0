From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH v7 09/11] scsi: ufs: connect to RPMB subsystem
Date: Mon, 7 Nov 2016 20:01:09 +0100
Message-ID: <20161107190109.GA5110@lst.de>
References: <1478548394-8184-1-git-send-email-tomas.winkler@intel.com> <1478548394-8184-10-git-send-email-tomas.winkler@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-doc-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1478548394-8184-10-git-send-email-tomas.winkler@intel.com>
Sender: linux-doc-owner@vger.kernel.org
To: Tomas Winkler <tomas.winkler@intel.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Ulf Hansson <ulf.hansson@linaro.org>, Adrian Hunter <adrian.hunter@intel.com>, James Bottomley <James.Bottomley@HansenPartnership.com>, "Martin K . Petersen" <martin.petersen@oracle.com>, Vinayak Holikatti <vinholikatti@gmail.com>, Andy Lutomirski <luto@kernel.org>, Arve =?iso-8859-1?B?SGr4bm5lduVn?= <arve@android.com>, Michael Ryleev <gmar@google.com>, Joao Pinto <Joao.Pinto@synopsys.com>, Christoph Hellwig <hch@lst.de>, Yaniv Gardi <ygardi@codeaurora.org>, Avri Altman <avri.altman@gmail.com>, linux-kernel@vger.kernel.org, linux-mmc@vger.kernel.org, linux-scsi@vger.kernel.org, linux-doc@vger.kernel.org, Alexander Usyskin <alexander.usyskin@intel.com>
List-Id: linux-scsi@vger.kernel.org

On Mon, Nov 07, 2016 at 09:53:12PM +0200, Tomas Winkler wrote:
> Register UFS RPMB LUN with the RPMB subsystem and provide
> implementation for the RPMB access operations. RPMB partition is
> accessed via a sequence of security protocol in and security protocol
> out commands with UFS specific parameters. This multi step process is
> abstracted into 4 basic RPMB commands.

This is a giant layering violation - the security protocol is not something
up to the LLDD but the core code.

And honestly the idea of defintining a security protocol in the UFS
spec is just as braindead.  If you care about this please take it up
with T10 to get RPMB support into one of the core SCSI specs instead
of a transport.
