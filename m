From: Greg KH <gregkh@linuxfoundation.org>
Subject: Re: [PATCH 10/28] proc: Add proc_mkdir_data() [RFC]
Date: Tue, 16 Apr 2013 17:58:55 -0700
Message-ID: <20130417005855.GC11541@kroah.com>
References: <20130416182550.27773.89310.stgit@warthog.procyon.org.uk>
 <20130416182630.27773.83021.stgit@warthog.procyon.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <devel-bounces@linuxdriverproject.org>
Content-Disposition: inline
In-Reply-To: <20130416182630.27773.83021.stgit@warthog.procyon.org.uk>
List-Unsubscribe: <http://driverdev.linuxdriverproject.org/mailman/options/devel>,
 <mailto:devel-request@linuxdriverproject.org?subject=unsubscribe>
List-Archive: <http://driverdev.linuxdriverproject.org/pipermail/devel/>
List-Post: <mailto:devel@linuxdriverproject.org>
List-Help: <mailto:devel-request@linuxdriverproject.org?subject=help>
List-Subscribe: <http://driverdev.linuxdriverproject.org/mailman/listinfo/devel>,
 <mailto:devel-request@linuxdriverproject.org?subject=subscribe>
Errors-To: devel-bounces@linuxdriverproject.org
Sender: "devel" <devel-bounces@linuxdriverproject.org>
To: David Howells <dhowells@redhat.com>
Cc: Neela Syam Kolli <megaraidlinux@lsi.com>, devel@driverdev.osuosl.org, Mauro Carvalho Chehab <mchehab@redhat.com>, linux-scsi@vger.kernel.org, Jerry Chuang <jerry-chuang@realtek.com>, linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org, viro@zeniv.linux.org.uk, linux-fsdevel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Tue, Apr 16, 2013 at 07:26:30PM +0100, David Howells wrote:
> Add proc_mkdir_data() to allow procfs directories to be created that are
> annotated at the time of creation with private data rather than doing this
> post-creation.  This means no access is then required to the proc_dir_entry
> struct to set this.
> 
> Signed-off-by: David Howells <dhowells@redhat.com>
> cc: Neela Syam Kolli <megaraidlinux@lsi.com>
> cc: Jerry Chuang <jerry-chuang@realtek.com>
> cc: Mauro Carvalho Chehab <mchehab@redhat.com>
> cc: linux-scsi@vger.kernel.org
> cc: devel@driverdev.osuosl.org
> cc: linux-wireless@vger.kernel.org
> ---

Acked-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
