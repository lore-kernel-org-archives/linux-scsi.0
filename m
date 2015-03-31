From: One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>
Subject: Re: [PATCH 3/3] libata: support host-aware ZAC devices
Date: Tue, 31 Mar 2015 13:56:34 +0100
Message-ID: <20150331135634.047af7b8@lxorguk.ukuu.org.uk>
References: <1427791963-90832-1-git-send-email-hare@suse.de>
	<1427791963-90832-4-git-send-email-hare@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <1427791963-90832-4-git-send-email-hare@suse.de>
Sender: linux-ide-owner@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: Tejun Heo <tj@kernel.org>, linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Tue, 31 Mar 2015 10:52:43 +0200
Hannes Reinecke <hare@suse.de> wrote:

> Byte 69 bits 0:1 in the IDENTIFY DEVICE data are proposed
> to indicate a host-aware ZAC device.
> And whenever we detect a ZAC-compatible device we should
> be displaying the zoned block characteristics VPD page.

I don't think this belongs upstream as is - because this is a "proposed"
- it might change and then we have Linux boxes in the field randomly
misinterpreting bits if instead other bits are used or the definition
changes.

Until it's officially in the spec there ought IMHO to be a boot option to
enable the test.

Alan
