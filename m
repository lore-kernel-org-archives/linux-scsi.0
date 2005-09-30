From: Arjan van de Ven <arjan@infradead.org>
Subject: RE: I request inclusion of SAS Transport Layer and AIC-94xx
	intothe kernel
Date: Fri, 30 Sep 2005 20:49:25 +0200
Message-ID: <1128106165.3012.17.camel@laptopd505.fenrus.org>
References: <9BB4DECD4CFE6D43AA8EA8D768ED51C20F46D5@xbl3.ma.emulex.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1030309AbVI3Stp@vger.kernel.org>
In-Reply-To: <9BB4DECD4CFE6D43AA8EA8D768ED51C20F46D5@xbl3.ma.emulex.com>
Sender: linux-kernel-owner@vger.kernel.org
To: James.Smart@Emulex.Com
Cc: mark_salyzyn@adaptec.com, Luben_Tuikov@adaptec.com, andrew.patterson@hp.com, dougg@torque.net, torvalds@osdl.org, ltuikov@yahoo.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Fri, 2005-09-30 at 14:36 -0400, James.Smart@Emulex.Com wrote:
> > On Fri, 2005-09-30 at 13:07 -0400, Salyzyn, Mark wrote:
> > > At the SAS BOF, I indicated that it would not be much trouble to
> > > translate the CSMI handler in the aacraid driver to a similar sysfs
> > > arrangement. If such info can be mined from a firmware 
> > based RAID card,
> > > every driver should be able to do so. The spec writers 
> > really need to
> > > consider rewriting SDI for sysfs (if they have not already) and move
> > > away from an ABI.
> > 
> > that makes me wonder... why and how does T10 control linux abi's ??
> 
> Agreed. The most they should be doing is defining a library interface, and
> letting the library hide the system specifics (like t11 and hbaapi, who
> still got parts wrong).  It also changes the argument from being a "linux abi"
> to being "a defacto application/library abi". 

and not an ABI but an API. Which is important to allow the OS designers
deal with architecture differences better.
