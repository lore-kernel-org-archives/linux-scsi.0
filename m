From: Matthew Wilcox <willy@infradead.org>
Subject: Re: [PATCH 0/3] Use sbitmap instead of percpu_ida
Date: Thu, 14 Jun 2018 19:37:31 -0700
Message-ID: <20180615023731.GA5706@bombadil.infradead.org>
References: <20180612190545.10781-1-willy@infradead.org>
	<yq136xols59.fsf@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <virtualization-bounces@lists.linux-foundation.org>
Content-Disposition: inline
In-Reply-To: <yq136xols59.fsf@oracle.com>
List-Unsubscribe: <https://lists.linuxfoundation.org/mailman/options/virtualization>,
	<mailto:virtualization-request@lists.linux-foundation.org?subject=unsubscribe>
List-Archive: <http://lists.linuxfoundation.org/pipermail/virtualization/>
List-Post: <mailto:virtualization@lists.linux-foundation.org>
List-Help: <mailto:virtualization-request@lists.linux-foundation.org?subject=help>
List-Subscribe: <https://lists.linuxfoundation.org/mailman/listinfo/virtualization>,
	<mailto:virtualization-request@lists.linux-foundation.org?subject=subscribe>
Sender: virtualization-bounces@lists.linux-foundation.org
Errors-To: virtualization-bounces@lists.linux-foundation.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Juergen Gross <jgross@suse.com>, Jens Axboe <axboe@kernel.dk>, kvm@vger.kernel.org, linux-scsi@vger.kernel.org, netdev@vger.kernel.org, linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org, virtualization@lists.linux-foundation.org, target-devel@vger.kernel.org, qla2xxx-upstream@qlogic.com, linux1394-devel@lists.sourceforge.net, Kent Overstreet <kent.overstreet@gmail.com>
List-Id: linux-scsi@vger.kernel.org

On Thu, Jun 14, 2018 at 10:06:58PM -0400, Martin K. Petersen wrote:
> 
> Matthew,
> 
> > Removing the percpu_ida code nets over 400 lines of removal.  It's not
> > as spectacular as deleting an entire architecture, but it's still a
> > worthy reduction in lines of code.
> 
> Since most of the changes are in scsi or target, should I take this
> series through my tree?

I'd welcome that.  Nick seems to be inactive as target maintainer;
his tree on kernel.org hasn't seen any updates in five months.

Thanks!
