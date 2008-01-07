From: David Brownell <david-b@pacbell.net>
Subject: Re: [PATCH 0/7] convert semaphore to mutex in struct class
Date: Mon, 7 Jan 2008 01:01:13 -0800
Message-ID: <200801070101.15168.david-b@pacbell.net>
References: <20080103055019.GA4885@darkstar.te-china.tietoenator.com>
	<20080107020944.GA3637@darkstar.te-china.tietoenator.com>
	<20080107084528.GA8365@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux1394-devel-bounces@lists.sourceforge.net>
In-Reply-To: <20080107084528.GA8365@suse.de>
Content-Disposition: inline
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/linux1394-devel>,
	<mailto:linux1394-devel-request@lists.sourceforge.net?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=linux1394-devel>
List-Post: <mailto:linux1394-devel@lists.sourceforge.net>
List-Help: <mailto:linux1394-devel-request@lists.sourceforge.net?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/linux1394-devel>,
	<mailto:linux1394-devel-request@lists.sourceforge.net?subject=subscribe>
Sender: linux1394-devel-bounces@lists.sourceforge.net
Errors-To: linux1394-devel-bounces@lists.sourceforge.net
To: Greg KH <gregkh@suse.de>
Cc: a.zummo@towertech.it, dbrownell@users.sourceforge.net, Dave Young <hidave.darkstar@gmail.com>, linux-scsi@vger.kernel.org, cbou@mail.ru, peterz@infradead.org, linux-kernel@vger.kernel.org, James.Bottomley@hansenpartnership.com, krh@redhat.com, Stefan Richter <stefanr@s5r6.in-berlin.de>, stern@rowland.harvard.edu, rtc-linux@googlegroups.com, spi-devel-general@lists.sourceforge.net, linux1394-devel@lists.sourceforge.net, dwmw2@infradead.org, davem@davemloft.net, jarkao2@gmail.com
List-Id: linux-scsi@vger.kernel.org

On Monday 07 January 2008, Greg KH wrote:
> Most of the non-driver core code should be converted to not use the
> lock in the class at all. =A0They should use a local lock instead.

Or better yet, that yet-to-be-written class_for_each_instance()
iterator ... :)


-------------------------------------------------------------------------
This SF.net email is sponsored by: Microsoft
Defy all challenges. Microsoft(R) Visual Studio 2005.
http://clk.atdmt.com/MRT/go/vse0120000070mrt/direct/01/
