From: Luben Tuikov <luben@splentec.com>
Subject: Re: [PATCH] fixes and cleanups for the new command allocation code
Date: Tue, 04 Feb 2003 13:08:20 -0500
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <3E400194.2000707@splentec.com>
References: <20030204162326.A30755@lst.de> <20030204081616.A24105@beaverton.ibm.com> <20030204175146.A31515@lst.de> <20030204091955.A24785@beaverton.ibm.com> <3E3FFEEF.3040506@splentec.com> <20030204190331.A32115@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>
Cc: Patrick Mansfield <patmans@us.ibm.com>, James.Bottomley@steeleye.com, linux-scsi@vger.kernel.org

Christoph Hellwig wrote:
> 
> The trend is to have as much variables as possible static to one source
> file and if that is not possible have it global in C language scope but
> not exported to modules.

I was (of course) referring to those ``global in C language scope''.
I think that it would be cleaner to encapsulate them in a variable of
type structure, which will abide by the same rules of course.  My opinion
is that this would be cleaner.

-- 
Luben



