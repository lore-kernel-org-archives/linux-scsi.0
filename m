From: Bart Van Assche <Bart.VanAssche@wdc.com>
Subject: Re: [PATCH 0/3] Use sbitmap instead of percpu_ida
Date: Tue, 12 Jun 2018 20:06:18 +0000
Message-ID: <27ef5cf260a14606df099ff112a7ab1b36b02395.camel@wdc.com>
References: <20180612190545.10781-1-willy@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <virtualization-bounces@lists.linux-foundation.org>
In-Reply-To: <20180612190545.10781-1-willy@infradead.org>
Content-Language: en-US
Content-ID: <8A3C87E23D01794D89BD770501E0C037@namprd04.prod.outlook.com>
List-Unsubscribe: <https://lists.linuxfoundation.org/mailman/options/virtualization>,
	<mailto:virtualization-request@lists.linux-foundation.org?subject=unsubscribe>
List-Archive: <http://lists.linuxfoundation.org/pipermail/virtualization/>
List-Post: <mailto:virtualization@lists.linux-foundation.org>
List-Help: <mailto:virtualization-request@lists.linux-foundation.org?subject=help>
List-Subscribe: <https://lists.linuxfoundation.org/mailman/listinfo/virtualization>,
	<mailto:virtualization-request@lists.linux-foundation.org?subject=subscribe>
Sender: virtualization-bounces@lists.linux-foundation.org
Errors-To: virtualization-bounces@lists.linux-foundation.org
To: "kvm@vger.kernel.org" <kvm@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>, "willy@infradead.org" <willy@infradead.org>, "virtualization@lists.linux-foundation.org" <virtualization@lists.linux-foundation.org>, "kent.overstreet@gmail.com" <kent.overstreet@gmail.com>, "linux1394-devel@lists.sourceforge.net" <linux1394-devel@lists.sourceforge.net>, "jgross@suse.com" <jgross@suse.com>, "axboe@kernel.dk" <axboe@kernel.dk>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "qla2xxx-upstream@qlogic.com" <qla2xxx-upstream@qlogic.com>, "target-devel@vger.kernel.org" <target-devel@vger.kernel.org>, "netdev@vger.kernel.org" <netdev@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

On Tue, 2018-06-12 at 12:05 -0700, Matthew Wilcox wrote:
> Removing the percpu_ida code nets over 400 lines of removal.  It's not
> as spectacular as deleting an entire architecture, but it's still a
> worthy reduction in lines of code.
> 
> Untested due to lack of hardware and not understanding how to set up a
> target platform.
> 
> Changes from v1:
>  - Fixed bugs pointed out by Jens in iscsit_wait_for_tag()
>  - Abstracted out tag freeing as requested by Bart
>  - Made iscsit_wait_for_tag static as pointed out by 0day

For the whole series:

Reviewed-by: Bart Van Assche <bart.vanassche@wdc.com>

Thanks,

Bart.
