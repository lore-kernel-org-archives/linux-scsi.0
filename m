From: "'patman@aracnet.com'" <patman@aracnet.com>
Subject: Re: proposed update to scsi_id needing review
Date: Thu, 9 Jun 2005 16:46:07 -0700
Message-ID: <20050609234607.GA30469@aracnet.com>
References: <C2EEB4E538D3DC48BF57F391F422779321AA82@SRMANNING.eng.emc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-hotplug-devel-admin@lists.sourceforge.net>
Content-Disposition: inline
In-Reply-To: <C2EEB4E538D3DC48BF57F391F422779321AA82@SRMANNING.eng.emc.com>
Sender: linux-hotplug-devel-admin@lists.sourceforge.net
Errors-To: linux-hotplug-devel-admin@lists.sourceforge.net
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/linux-hotplug-devel>,
	<mailto:linux-hotplug-devel-request@lists.sourceforge.net?subject=unsubscribe>
List-Post: <mailto:linux-hotplug-devel@lists.sourceforge.net>
List-Help: <mailto:linux-hotplug-devel-request@lists.sourceforge.net?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/linux-hotplug-devel>,
	<mailto:linux-hotplug-devel-request@lists.sourceforge.net?subject=subscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum=linux-hotplug-devel>
To: "goggin, edward" <egoggin@emc.com>
Cc: "'linux-hotplug-devel@lists.sourceforge.net'" <linux-hotplug-devel@lists.sourceforge.net>, "'linux-scsi@vger.kernel.org'" <linux-scsi@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

Looks like some line wraps, just resend with patch as an attachment.

Thanks ...

-- Patrick Mansfield

On Thu, Jun 09, 2005 at 07:15:42PM -0400, goggin, edward wrote:

> +static int do_scsi_page83_prespc3_inquiry(struct sysfs_device *scsi_dev,
> int fd,
> +				          char *serial, int len)
> +{


-------------------------------------------------------
This SF.Net email is sponsored by: NEC IT Guy Games.  How far can you shotput
a projector? How fast can you ride your desk chair down the office luge track?
If you want to score the big prize, get to know the little guy.  
Play to win an NEC 61" plasma display: http://www.necitguy.com/?r=20
